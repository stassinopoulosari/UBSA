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
    
    /**
     Month
     
     Int month 0-11
     */
    public var month: Int {
        didSet {
            if(month < 0 || month > 11) {
                month = 0;
            }
        }
    }
    
    /**
     Year
     
     Int year 1970-present
     */
    public var year: Int {
        didSet {
            if(year < 1970) {
                year = 1970;
            }
        }
    }
    
    private init(withSchedules schedules: [UBSASchedule?], month: Int, year: Int) {
        self.schedules = schedules;
        self.month = month;
        self.year = year;
    }
    
    /**
     Make a UBSA Calendar from a Firebase reference
     
     - Parameter withReference: Database reference at which you can find the calendar string
     - Parameter scheduleTable: UBSA Schedule Table with the schedules for the school in question
     - Parameter completion: Function taking optional UBSA Calendar (nil if failed)
     */
    public static func makeCalendar(withReference reference: DatabaseReference, scheduleTable: UBSAScheduleTable, month: Int, year: Int, completion callback: @escaping (_: UBSACalendar?)->Void) {
        if(month < 0 || month > 11) {
            callback(nil);
            return;
        }
        if(year < 1970) {
            callback(nil);
            return;
        }
        reference.observeSingleEvent(of: .value)  { (calendarSnapshot) in
            if(!calendarSnapshot.exists()) {
                callback(nil);
                return;
            }
            if let snapshotValue = calendarSnapshot.value {
                if let snapshotDict = snapshotValue as? [String: Any] {
                    if let calendarString = snapshotDict["data"] as? String {
                        let parsedSchedules = parse(calendarString: calendarString, withScheduleTable: scheduleTable);
                        if let schedules = parsedSchedules {
                            callback(UBSACalendar(withSchedules: schedules, month: month, year: year));
                            return;
                        } else {
                            callback(nil);
                            return;
                        }
                    } else {
                        callback(nil);
                        return;
                    }
                } else {
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
}
