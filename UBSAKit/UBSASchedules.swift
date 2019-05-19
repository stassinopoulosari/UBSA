//
//  UBSASchedule.swift
//  UBSAKit
//
//  Created by Ari Stassinopoulos on 5/9/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import Foundation
import Firebase

/**
 UBSA Schedules
 */
public struct UBSASchedules {
    ///Schedules: table of schedules by identifier
    public var schedules: [String: UBSASchedule];
    
    private init(withSchedules schedules: [String: UBSASchedule]) {
        self.schedules = schedules;
    }
    
    
    /// Make a schedule table
    ///
    /// - Parameters:
    ///     - c: Context
    ///     - withReference: The reference from which to make the table
    ///     - completion: A callback function
    public static func makeScheduleTable(_ c: UBSAContext, withReference reference: DatabaseReference, completion callback: @escaping (_:UBSASchedules?)->Void) {
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if(!snapshot.exists()) {
                callback(nil);
                return;
            }
            if let referenceValue = snapshot.value, let referenceDict = referenceValue as? [String: Any] {
                var schedules: [String:UBSASchedule] = [:];
                for (key, child) in referenceDict {
                    if let scheduleDict = child as? [String: Any] {
                        let schedule = parse(c, withDict: scheduleDict);
                        schedules[key] = schedule;
                    } else {
                        continue;
                    }
                }
                callback(UBSASchedules(withSchedules: schedules));
            } else {
                callback(nil);
                return;
            }
        }
    }
    
    private static func parse(_ c: UBSAContext, withDict scheduleDict: [String: Any]) -> UBSASchedule {
        var name = "";
        var periods: [UBSAPeriod] = [];
        var prev: UBSAPeriod? = nil;
        var hidden: Bool = false;
        for (periodKey, period) in scheduleDict {
            if(periodKey == "name") {
                if let nameString = period as? String {
                    name = nameString;
                }
                continue;
            }
            if(periodKey == "hidden") {
                if let hiddN = period as? Bool {
                    hidden = hiddN;
                }
                continue;
            }
            if let periodData = period as? [String: Any] {
                let keys = periodData.keys;
                var period: UBSAPeriod? = nil;
                if(!keys.contains("name")) {
                    continue;
                }
                if let name = periodData["name"] as? String {
                    if(keys.contains("start") && keys.contains("end")) {
                        if let startTime = periodData["start"] as? String,
                            let endTime = periodData["end"] as? String {
                            period = UBSAPeriod(c, withStartTime: startTime, withEndTime: endTime, withName: name);
                        }
                    } else if(keys.contains("start") && keys.contains("len")) {
                        if let startTime = periodData["start"] as? String,
                            let len = periodData["len"] as? NSNumber {
                            period = UBSAPeriod(c, withStartTime: startTime, withLength: Int(truncating: len), withName: name);
                        }
                    } else if(keys.contains("end") && prev != nil) {
                        if let endTime = periodData["end"] as? String, let previous = prev {
                            period = UBSAPeriod(c, afterPrevious: previous, withEndTime: endTime, withName: name);
                        }
                    } else if(keys.contains("len") && prev != nil) {
                        if let len = periodData["len"] as? NSNumber, let previous = prev {
                            period = UBSAPeriod(c, afterPrevious: previous, withLength: Int(truncating: len), withName: name);
                        }
                    }
                }
                if(period != nil) {
                    periods.append(period ?? UBSAPeriod(c, withStartTime: "00:00", withEndTime: "00:00", withName: name));
                }
                prev = period;
            }
            
        }
        return UBSASchedule(withPeriods: periods, name: name, hidden: hidden);
    }
    
    ///Make a path for a schedule
    ///- Parameter c: Context
    ///- Returns: A reference for the schedule
    public static func scheduleTablePath(_ c: UBSAContext) -> DatabaseReference {
        let path = "schedules";
        return c.database.child(path);
    }
}


/**
 UBSA Schedule
 */
public struct UBSASchedule {
    
    ///Periods in the schedule
    public var periods: [UBSAPeriod];
    
    ///Name of the schedule
    public var name: String;
    
    ///Display schedule in list?
    public var hidden: Bool;
    
    /// Initializer
    /// - Parameters:
    ///     - periods: Periods of the schedule
    ///     - name: Name of the schedule
    ///     - hidden: Is the schedule hidden?
    public init(withPeriods periods: [UBSAPeriod], name: String, hidden: Bool) {
        self.periods = periods;
        self.name = name;
        self.hidden = hidden;
    }
    
    ///Get a the current period
    /// - Parameters:
    ///     - fromDate: Date to get the period
    /// - Returns: The current period or nil if there is none.
    public func getPeriod(fromDate date: Date) -> UBSAPeriod? {
        let calendar = Calendar(identifier: .gregorian);
        let hrs: Int = calendar.component(.hour, from: date);
        let mins: Int = calendar.component(.minute, from: date);
        for period in periods {
            let startComponents = period.startTimeComponents;
            let endComponents = period.endTimeComponents;
            let isGreaterThanStart = hrs > startComponents.0 || (hrs == startComponents.0 && mins >= startComponents.1);
            
            let isSmallerThanEnd = hrs < endComponents.0 || (hrs == endComponents.0 && mins < endComponents.1);
            
            if(isGreaterThanStart && isSmallerThanEnd) {
                return period;
            }
        }
        return nil;
    }
    
    
}
