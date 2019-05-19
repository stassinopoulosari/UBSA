//
//  UBSAPeriod.swift
//  UBSAKit
//
//  Created by Ari Stassinopoulos on 5/9/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import Foundation

/**
 UBSA Period
 */
public class UBSAPeriod: Equatable {
    
    /// Equals (for equatable)
    ///
    /// - Parameters:
    ///     - lhs: The left side of ==
    ///     - rhs: The right sie of ===
    /// - Returns: Whether the periods are equivalent
    public static func == (lhs: UBSAPeriod, rhs: UBSAPeriod) -> Bool {
        return lhs.startTimeComponents == rhs.startTimeComponents && lhs.endTimeComponents == rhs.endTimeComponents && lhs.name == rhs.name;
    }
    
    /// Name of the schedule
    public var name: String;
    
    /// Context
    public var context: UBSAContext;
    
    ///Start of the period "00:00" 24-hour time
    public var startTime: String;
    
    ///End of the period "00:00" 24-hour time
    public var endTime: String;
    
    ///Components of the start time (split at :)
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
    
    ///Components of the end time (split at :)
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
    
    ///Rendered start time with user time style
    public var startTimeDisplay: String {
        return renderComponents(startTimeComponents)
    }
    
    ///Rendered end time with user time style
    public var endTimeDisplay: String {
        return renderComponents(endTimeComponents);
    }
    
    private func renderComponents(_ components: (Int, Int)) -> String{
        let (hh, mm) = components;
        if(using12hClockFormat()) {
            return "\(hh % 12 == 0 ? 12 : hh % 12):\(mm < 10 ? "0\(mm)" : "\(mm)") \(hh >= 12 ? "PM" : "AM")";
        } else {
            return "\(hh < 10 ? "0\(hh)" : "\(hh)"):\(mm < 10 ? "0\(mm)" : "\(mm)")";
        }
    }
    
    ///Default initializer
    /// - Parameters:
    ///     - c: Context
    ///     - withStartTime: Period start time
    ///     - withEndTime: Period end time
    ///     - withName: Name of the period
    public init(_ c: UBSAContext, withStartTime startTime: String, withEndTime endTime: String, withName name: String) {
        self.startTime = startTime;
        self.endTime = endTime;
        self.name = name;
        self.name = name;
        self.context = c;
    }
    
    ///Start-len initializer
    /// - Parameters:
    ///     - c: Context
    ///     - withStartTime: Period start time
    ///     - withLength: Length of the period
    ///     - withName: Name of the period
    init(_ c: UBSAContext, withStartTime startTime: String, withLength len: Int, withName name: String) {
        self.startTime = startTime;
        self.endTime = "";
        self.context = c;
        self.name = name;
        endTime = add(minutes: len, toTime: startTime);
    }
    
    ///Previous-len initializer
    /// - Parameters:
    ///     - c: Context
    ///     - afterPrevious: Previous period
    ///     - withLength: Length of the period
    ///     - withName: Name of the period
    init(_ c: UBSAContext, afterPrevious prev: UBSAPeriod, withLength len: Int, withName name: String) {
        startTime = prev.endTime;
        endTime = "";
        self.name = name;
        self.context = c;
        endTime = add(minutes: len, toTime: startTime);
    }
    
    ///Previous-end initializer
    /// - Parameters:
    ///     - c: Context
    ///     - afterPrevious: Previous period
    ///     - withEndTime: Period end time
    ///     - withName: Name of the period
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
        let locale = NSLocale.current;
        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!;
        return formatter.contains("a");
    }
    
    /// Distance from the end of the period
    ///
    /// - Parameters:
    ///     - date: Date for the calculation
    /// - Returns: A timeInterval with how long is left in the period
    public func distanceFromEnd(date: Date) -> TimeInterval {
        let calendar = Calendar(identifier: .gregorian);
        let hh = calendar.component(.hour, from: date);
        let mm = calendar.component(.minute, from: date);
        let ss = calendar.component(.second, from: date);
        let (eHH, eMM) = endTimeComponents;
        let mLeft = 60 * (eHH - hh) + (eMM - mm);
        return TimeInterval(60 * (mLeft) - ss);
    }
    
    
}
