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
}
