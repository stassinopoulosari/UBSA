//
//  UBSAPeriod.swift
//  UBSAKit
//
//  Created by Ari Stassinopoulos on 5/9/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import Foundation

public class UBSAPeriod {
    
    public var name: String;
    
    public var context: UBSAContext;
    
    public var startTime: String;
    public var endTime: String;
    public var isPassingPeriod: Bool = false;
    
    public var startTimeComponents: (Int, Int) {
        get {
            let sp = startTime.split(separator: ":");
            if(sp.count < 2) { return (0, 0); }
            if let startC = Int(String(sp[0])), let endC = Int(String(sp[1])) {
                return (startC, endC);
            } else {
                return (0, 0);
            }        }
    }
    
    public var endTimeComponents: (Int, Int) {
        get {
            let sp = endTime.split(separator: ":");
            if(sp.count < 2) { return (0, 0); }
            if let startC = Int(String(sp[0])), let endC = Int(String(sp[1])) {
                return (startC, endC);
            } else {
                return (0, 0);
            }
        }
    };
    
    public var startTimeDisplay: String {
        if(using12hClockFormat()) {
            let (hh, mm) = startTimeComponents;
            return "\(hh % 12):\(mm < 10 ? "0\(mm)" : "\(mm)") \(hh >= 12 ? "PM" : "AM")";
        } else {
            return startTime;
        }
    }
    
    public var endTimeDisplay: String {
        if(using12hClockFormat()) {
            let (hh, mm) = endTimeComponents;
            return "\(hh % 12):\(mm < 10 ? "0\(mm)" : "\(mm)") \(hh >= 12 ? "PM" : "AM")";
        } else {
            return endTime;
        }
    }
    
    init(_ c: UBSAContext, withStartTime startTime: String, withEndTime endTime: String, withName name: String) {
        self.startTime = startTime;
        self.endTime = endTime;
        self.name = name;
        self.name = name;
        self.context = c;
    }
    
    init(_ c: UBSAContext, withStartTime startTime: String, withLength len: Int, withName name: String) {
        self.startTime = startTime;
        self.endTime = "";
        self.context = c;
        self.name = name;
        endTime = add(minutes: len, toTime: startTime);
    }
    
    init(_ c: UBSAContext, afterPrevious prev: UBSAPeriod, withLength len: Int, withName name: String) {
        startTime = prev.endTime;
        endTime = "";
        self.name = name;
        self.context = c;
        endTime = add(minutes: len, toTime: startTime);
    }
    
    init(_ c: UBSAContext, afterPrevious prev: UBSAPeriod, withEndTime endTime: String, withName name: String) {
        startTime = prev.endTime;
        self.endTime = endTime;
        self.context = c;
        self.name = name;
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
    
    private func using12hClockFormat() -> Bool {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        let dateString = formatter.string(from: Date())
        let amRange = dateString.range(of: formatter.amSymbol)
        let pmRange = dateString.range(of: formatter.pmSymbol)
        
        return !(pmRange == nil && amRange == nil)
    }
}
