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
    
    ///Stores the identifier from the config
    public var identifier: String {
        return config.schoolIdentifier;
    }
    
    ///Allows access to the colour from the config
    public var colour: UIColor {
        return config.schoolColour;
    }
    
    ///Allows access to the text colour from the config
    public var textColour: UIColor {
        return UBSAColour.getTextColour(forColour: config.schoolColour);
    }
    
    ///Allows access to the name from the config
    public var name: String {
        return config.schoolName;
    }
    
    ///Database reference given the school identifier from the config
    public var database: DatabaseReference {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure();
        }
        return Database.database().reference().child("schools").child(config.schoolIdentifier);
    }
    
    ///UserDefaults instance
    public var defaults: UserDefaults? {
        return UserDefaults.init(suiteName: identifier);
    }
    
    ///Initialiser for UBSAContext, use with config object in main target
    public init(withConfig config: UBSAConfig) {
        self.config = config;
    }
    
}
