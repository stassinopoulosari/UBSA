//
//  UBSAConfig.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/8/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import Foundation
import UBSAKit

/**
 Configuration on app-level for UI and name
 */
struct AppConfig {
    
    ///UBSA config: Allows configuration of app-level data
    public static var ubsaConfig: UBSAConfig {
        get {
            let SCHOOL_NAME: String = "Dublin High School";
            let APP_NAME: String = "DHS Bell Schedule App";
            let SCHOOL_COLOUR: UIColor = UIColor(hue: 64.0/360.0, saturation: 1.0, brightness: 1.0,  alpha: 1.0);
            let SCHOOL_IDENTIFIER: String = "dublinHS";
            return UBSAConfig(withName: SCHOOL_NAME, appName: APP_NAME, schoolColour:SCHOOL_COLOUR, schoolIdentifier: SCHOOL_IDENTIFIER);
        }
    };
    
    ///Initializer is private to prevent initialisation (all methods are static)
    private init() {
    }
    
    public static let C: UBSAContext = UBSAContext(withConfig: ubsaConfig);
    
    
}
