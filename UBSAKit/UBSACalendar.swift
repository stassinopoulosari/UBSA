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
     
     index is day of the month - 1
     */
    public var schedules: [UBSASchedule?];
    
    
    private init(withSchedules schedules: [UBSASchedule?]) {
        self.schedules = schedules;
    }
    
    /**
     Make a UBSA Calendar from a Firebase reference
     
     - Parameter withReference: Database reference at which you can find the calendar string
     - Parameter scheduleTable: UBSA Schedule Table with the schedules for the school in question
     - Parameter completion: Function taking optional UBSA Calendar (nil if failed)
     */
    public static func makeCalendar(withReference reference: DatabaseReference, scheduleTable: UBSAScheduleTable, completion callback: @escaping (_: UBSACalendar?)->Void) {
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
                        callback(UBSACalendar(withSchedules: schedules));
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
    
    private static func parse(calendarString calendarStringWComments: String, withScheduleTable scheduleTable: UBSAScheduleTable) -> [UBSASchedule?]? {
        var toReturn = [UBSASchedule?]();
        let calendarString = calendarStringWComments.replacingOccurrences(of: #"\(([^)])*\)"#, with: "", options: .regularExpression);
        let splitCalendar = calendarString.split(separator: ",");
        if (splitCalendar.count == 0) {
            return nil;
        }
        for calendarCode in splitCalendar {
            let calendarCodeString: String = String(calendarCode).trimmingCharacters(in: .whitespacesAndNewlines);
            if(!scheduleTable.schedules.keys.contains(calendarCodeString)) {
                toReturn.append(nil);
            } else {
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
    
    public static func calendarPath(_ c: UBSAContext, fromDate date: Date) -> DatabaseReference {
        let calendar = Calendar(identifier: .gregorian);
        let year: Int = calendar.component(.year, from: date)
        let month: Int = calendar.component(.month, from: date);
        return generateCalendarPath(c, year: year, month: month);
    }
    
    public static func day(fromDate date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian);
        let day: Int = calendar.component(.day, from: date);
        return day;
    }
    
    public func getSchedule(forDay day: Int) -> UBSASchedule? {
        let index = day;
        if let schedule = schedules[index] {
            return schedule;
        } else {
            return nil;
        }
    }
}
