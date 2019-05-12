//
//  UBSAContext.swift
//  UBSAKit
//
//  Created by Ari Stassinopoulos on 5/8/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import Foundation
import UIKit
import Firebase

/**
 UBSA Context
 
 Similar to Android Context, allows for database access and other shared components
*/
public class UBSAContext {
    
    ///Stores the configuration provided in init
    public var config: UBSAConfig;
    
    ///Allows access to the colour from the config
    public var colour: UIColor {
        get {
            return config.schoolColour;
        }
    }
    
    ///Allows access to the text colour from the config
    public var textColour: UIColor {
        get {
            return UBSAColour.getTextColour(forColour: config.schoolColour);
        }
    }
    
    ///Allows access to the name from the config
    public var name: String {
        get {
            return config.schoolName;
        }
    }
    
    ///Database reference given the school identifier from the config
    public var database: DatabaseReference {
        get {
            return Database.database().reference().child("schools").child(config.schoolIdentifier);
        }
    }
    
    //public var symbols: [UBSASymbol];
    
    
    public init(withConfig config: UBSAConfig) {
        self.config = config;
    }
    
}
