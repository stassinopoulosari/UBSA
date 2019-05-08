//
//  UBSAConfig.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/8/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import Foundation
import UBSAKit

public class UBSAAppConfig {
    
    private init() {}
    
    public static var ubsaContext: UBSAContext {
        get {
            return UBSAContext(self.ubsaConfig);
        }
    }
    public static var c: UBSAContext {
        get {
            return ubsaContext;
        }
    }
    public static var ubsaConfig: UBSAConfig {
        get {
            let SCHOOL_NAME: String = "Sample School";
            let SCHOOL_COLOUR: UIColor = UIColor(hue: 39.0/360, saturation: 1.0, brightness: 0.976,  alpha: 1.0);
            let SCHOOL_IDENTIFIER: String = "sampleSchool";
            return UBSAConfig(withName: SCHOOL_NAME, schoolColour:SCHOOL_COLOUR, schoolIdentifier: SCHOOL_IDENTIFIER);
        }
    };
    
}
