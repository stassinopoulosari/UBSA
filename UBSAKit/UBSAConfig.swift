//
//  UBSAConfig.swift
//  UBSAKit
//
//  Created by Ari Stassinopoulos on 5/8/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import Foundation

/**
 UBSA Configuration
 
 Structure for the configuration in the app module to fit
 */
public struct UBSAConfig {
    ///School name for internal app data
    public var schoolName: String;
    
    ///School colour for the backgrounds
    public var schoolColour: UIColor;
    
    ///School identifier for the database
    public var schoolIdentifier: String;
    
    ///Name for the app
    public var appName: String;
    
    ///Basic initialiser
    public init(withName schoolName: String, appName: String, schoolColour: UIColor, schoolIdentifier: String) {
        self.schoolName = schoolName;
        self.schoolColour = schoolColour;
        self.appName = appName;
        self.schoolIdentifier = schoolIdentifier;
    }
}
