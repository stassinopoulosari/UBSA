//
//  UBSAScheduleTable.swift
//  UBSAKit
//
//  Created by Ari Stassinopoulos on 5/9/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import Foundation
import FirebaseDatabase

/**
 UBSA Schedule Table
 */
public struct UBSAScheduleTable {
    ///Schedules: table of schedules by identifier
    public var schedules: [String: UBSASchedule];
    
    private init(withSchedules schedules: [String: UBSASchedule]) {
        self.schedules = schedules;
    }
    
    public static func makeScheduleTable(_ c: UBSAContext, withReference reference: DatabaseReference, completion callback: @escaping (_:UBSAScheduleTable?)->Void) {
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
                callback(UBSAScheduleTable(withSchedules: schedules));
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
        for (periodKey, period) in scheduleDict {
            if(periodKey == "name") {
                if let nameString = period as? String {
                    name = nameString;
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
        return UBSASchedule(withPeriods: periods, name: name);
    }
    
    public static func scheduleTablePath(_ c: UBSAContext) -> DatabaseReference {
        let path = "schedules";
        return c.database.child(path);
    }
}
