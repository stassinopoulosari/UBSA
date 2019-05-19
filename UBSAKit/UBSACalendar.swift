//
//  UBSACalendar.swift
//  UBSAKit
//
//  Created by Ari Stassinopoulos on 5/9/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import Foundation
import FirebaseDatabase

/**
 UBSA Calendar
 
 Precomputed calendar function
 */
public class UBSACalendar {
    
    /**
     Schedules
     
     index is day of the month
     */
    public var schedules: [UBSASchedule?];
    
    ///Available schedules
    public var scheduleTable: UBSASchedules;
    
    private init(withSchedules schedules: [UBSASchedule?], scheduleTable: UBSASchedules) {
        self.schedules = schedules;
        self.scheduleTable = scheduleTable;
    }
    
    /**
     Make a UBSA Calendar from a Firebase reference
     
     - Parameter withReference: Database reference at which you can find the calendar string
     - Parameter scheduleTable: UBSA Schedule Table with the schedules for the school in question
     - Parameter completion: Function taking optional UBSA Calendar (nil if failed)
     */
    public static func makeCalendar(withReference reference: DatabaseReference, scheduleTable: UBSASchedules, completion callback: @escaping (_: UBSACalendar?)->Void) {
        reference.observeSingleEvent(of: .value)  { (calendarSnapshot) in
            if(!calendarSnapshot.exists()) {
                print("Calendar does not exist");
                callback(nil);
                return;
            }
            if let snapshotValue = calendarSnapshot.value {
                if let calendarString = snapshotValue as? String {
                    let parsedSchedules = parse(calendarString: calendarString, withScheduleTable: scheduleTable);
                    if let schedules = parsedSchedules {
                        callback(UBSACalendar(withSchedules: schedules, scheduleTable:  scheduleTable));
                        return;
                    } else {
                        callback(nil);
                        return;
                    }
                } else {
                    print("Calendar is not a string");
                    return callback(nil);
                }
            }
        }
    }
    
    private static func parse(calendarString calendarStringWComments: String, withScheduleTable scheduleTable: UBSASchedules) -> [UBSASchedule?]? {
        var toReturn: [UBSASchedule?] = [];
        let calendarString = calendarStringWComments.replacingOccurrences(of: #"\(([^)])*\)"#, with: "", options: .regularExpression);
        print(calendarString);
        let splitCalendar = calendarString.split(separator: ",", maxSplits: .max, omittingEmptySubsequences: false);
        if (splitCalendar.count == 0) {
            return nil;
        }
        print(splitCalendar);
        for calendarCode in splitCalendar {
            let calendarCodeString: String = String(calendarCode).trimmingCharacters(in: .whitespacesAndNewlines);
            print(calendarCode);
            if(!scheduleTable.schedules.keys.contains(calendarCodeString)) {
                print("nil");
                toReturn.append(nil);
            } else {
                print("unNil");
                toReturn.append(scheduleTable.schedules[calendarCodeString]);
            }
        }
        return toReturn;
    }
    
    private static func generateCalendarPath(_ c: UBSAContext, year: Int, month: Int) -> DatabaseReference {
        let yearStr = "\(year)";
        let monthStr = month < 10 ? "0\(month)" : "\(month)";
        return c.database.child("calendars/\(yearStr)/\(monthStr)");
    }
    
    /**
     Calendar path from a context and a date
     
     - Parameter c: Context
     - Parameter fromDate: The date for which to generate a path
     
     - Returns: A DatabaseReference for the calendar
     */
    public static func calendarPath(_ c: UBSAContext, fromDate date: Date) -> DatabaseReference {
        let calendar = Calendar(identifier: .gregorian);
        let year: Int = calendar.component(.year, from: date)
        let month: Int = calendar.component(.month, from: date);
        return generateCalendarPath(c, year: year, month: month);
    }
    
    /**
     Date of the month
     
     - Parameter fromDate: Date to generate day of month
     
     - Returns: Date of the month
     */
    public static func day(fromDate date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian);
        let day: Int = calendar.component(.day, from: date);
        return day;
    }
    
    /**
     Get the schedule for a day
     
     - Parameter forDay: The index in the array
     
     - Returns: Schedule if one is found
     */
    public func getSchedule(forDay day: Int) -> UBSASchedule? {
        let index = day;
        
        if let schedule = schedules[index] {
            print(schedule.name);
            return schedule;
        } else {
            return nil;
        }
    }
}
