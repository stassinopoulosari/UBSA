//
//  UBSAPeriod.swift
//  UBSAKit
//
//  Created by Ari Stassinopoulos on 5/9/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import Foundation

public struct UBSAPeriod {
    
    private var symbol: String? = nil;
    private var name: String? = nil;
    
    private var context: UBSAContext? = nil;
    
    public mutating func setContext(_ context: UBSAContext) -> UBSAPeriod {
        self.context = context;
        return self;
    }
    
    public var startTime: String;
    public var endTime: String;
    public var isPassingPeriod: Bool = false;
    
    
    init(withStartTime startTime: String, withEndTime endTime: String) {
        self.startTime = startTime;
        self.endTime = endTime;
    }
    
    init(withStartTime startTime: String, withLength len: Int) {
        self.startTime = startTime;
        self.endTime = "";
        self.endTime = add(minutes: len, toTime: startTime)
    }
    
    init(afterPrevious prev: UBSAPeriod, withLength len: Int) {
        startTime = prev.endTime;
        endTime = "";
        endTime = add(minutes: len, toTime: startTime);
    }
    
    init(afterPrevious prev: UBSAPeriod, withEndTime endTime: String) {
        startTime = prev.endTime;
        self.endTime = endTime;
    }
    
    private func add(minutes len: Int, toTime startTime: String) -> String {
        if(len < 0) {
            return startTime;
        }
        var startTimeComponents = startTime.split(separator: ":");
        if(startTimeComponents.count < 2 || startTimeComponents.count > 2) {
            return startTime;
        }
        let hoursString = startTimeComponents[0];
        let minutesString = startTimeComponents[1];
        if var hours = Int(hoursString), var minutes = Int(minutesString) {
            minutes = minutes + len;
            while(minutes > 60) {
                hours += 1;
                minutes -= 60;
                while(hours > 23) {
                    hours -= 24;
                }
            }
            return "\(hours < 10 ? "0\(hours)" : String(hours)):\(minutes < 10 ? "0\(minutes)" : String(minutes))";
        }
        return startTime;
    }
}
