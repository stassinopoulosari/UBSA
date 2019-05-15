//
//  UBSASchedule.swift
//  UBSAKit
//
//  Created by Ari Stassinopoulos on 5/9/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import Foundation

/**
 UBSA Schedule
 */
public struct UBSASchedule {
        
    public var periods: [UBSAPeriod];
    public var name: String;
    
    init(withPeriods periods: [UBSAPeriod], name: String) {
        self.periods = periods;
        self.name = name;
    }
    
    public func getPeriod(fromDate date: Date) -> UBSAPeriod? {
        let calendar = Calendar(identifier: .gregorian);
        let hrs: Int = calendar.component(.hour, from: date);
        let mins: Int = calendar.component(.minute, from: date);
        for period in periods {
            let startComponents = period.startTimeComponents;
            let endComponents = period.endTimeComponents;
            let isGreaterThanStart = hrs >= startComponents.0 && mins >= startComponents.1;
            let isSmallerThanEnd = hrs <= endComponents.0 && mins < endComponents.1;
            if(isGreaterThanStart && isSmallerThanEnd) {
                return period;
            }
        }
        return nil;
    }
    
    
}
