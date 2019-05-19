//
//  UBSASymbols.swift
//  UBSAKit
//
//  Created by Ari Stassinopoulos on 5/9/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import Foundation
import FirebaseDatabase

/**
 UBSA Symbols
 
 Stores a table of symbols; generable from a database reference.
 */
public class UBSASymbols {
    
    ///Symbols stored in the UBSASymbols
    public var symbols: [UBSASymbol];
    
    ///Initialize with a symbol table
    public init(withSymbols symbols: [UBSASymbol]) {
        self.symbols = symbols;
    }
    
    ///Render a string with the symbols
    public func render(templateString: String) -> String {
        var renderedString = templateString;
        for symbol in symbols {
            renderedString = symbol.render(templateString: renderedString);
        }
        return renderedString;
    }
    
    ///Make a table of symbols from a db reference;
    public static func makeSymbols(_ c: UBSAContext, fromReference reference: DatabaseReference, completion callback: @escaping (UBSASymbols?) -> Void) {
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if(snapshot.exists()) {
                if let snapshotValue = snapshot.value, let snapshotDict = snapshotValue as? [String: Any] {
                    var toReturn = [UBSASymbol]();
                    for (key, symbolEntry) in snapshotDict {
                        if let valueDict = symbolEntry as? [String: Any] {
                            if let valueString = valueDict["value"] as? String {
                                let configurable = valueDict["configurable"] as? Bool ?? false;
                                toReturn.append(UBSASymbol(c, identifier: key, defaultValue: valueString, configurable: configurable));
                            } else {
                                continue;
                            }
                        } else {
                            continue;
                        }
                    }
                    return callback(UBSASymbols(withSymbols: toReturn)); // Success condition
                } else {
                    return callback(nil);
                }
            } else {
                return callback(nil);
            }
        }
    }
    
    ///Get the path at which the symbols for a given context are stored
    public static func symbolPath(_ c: UBSAContext) -> DatabaseReference {
        return c.database.child("symbols");
    }
}

/**
 UBSA Symbol
 
 Container for data and utility methods for a symbol
 */
public struct UBSASymbol {
    
    //Mark: -Fields
    
    ///Database key
    public var identifier: String;
    
    ///Value to be shown in schedule
    public var value: String {
        get {
            if let storedValue = configuredValue {
                return storedValue;
            } else {
                return defaultValue;
            }
        }
    };
    
    ///Value stored in database
    public var defaultValue: String;
    
    ///Value configured by user
    public var configuredValue: String? {
        get {
            if let userDefaults = context.defaults,
                let storedValue = userDefaults.string(forKey: identifier) {
                return storedValue;
            }
            return nil;
        } set(newValue) {
            if let userDefaults = context.defaults {
                let key = identifier;
                userDefaults.setValue(newValue, forKey: key);
            }
        }
    };
    
    ///Is the symbol configurable?
    public var configurable: Bool;
    
    ///Stored context for configurability
    private var context: UBSAContext;
    
    //Mark: - Initializers
    
    /**
     Basic initializer
     
     - Parameter c: Context
     - Parameter identifier: The database identifier of the symbol
     - Parameter defaultValue: The database value of the symbol
     - Parameter configurable: Is the symbol configurable?
     */
    public init(_ c: UBSAContext, identifier: String, defaultValue: String, configurable: Bool) {
        context = c;
        self.defaultValue = defaultValue;
        self.identifier = identifier;
        self.configurable = configurable;
    }
    //Mark: - Functions
    /**
     Render from a template string
     
     - Parameter templateString: The string to be replaced
     
     - Returns: A string rendered from the value of the symbol; can be the original string.
     */
    public func render(templateString: String) -> String {
        return templateString.replacingOccurrences(of: "$(\(identifier))", with: value);
    }
    
    
    
    
}
