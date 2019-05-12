//
//  UBSASymbols.swift
//  UBSAKit
//
//  Created by Ari Stassinopoulos on 5/9/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import Foundation
import FirebaseDatabase

public class UBSASymbols {
    
    public var symbols: [UBSASymbol];
    
    public init(withSymbols symbols: [UBSASymbol]) {
        self.symbols = symbols;
    }
    
    public func render(templateString: String) -> String {
        var renderedString = templateString;
        for symbol in symbols {
            renderedString = symbol.render(templateString: renderedString);
        }
        return templateString;
    }
    
    public func render(symbolString: String) ->  String {
        for symbol in symbols {
            if(symbol.matches(symbolString: symbolString)) {
                return symbol.value;
            }
        }
        return symbolString;
    }
    
    public static func makeSymbols(fromReference reference: DatabaseReference, completion callback: @escaping ([UBSASymbol]?) -> Void) {
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if(snapshot.exists()) {
                if let snapshotValue = snapshot.value, let snapshotDict = snapshotValue as? [String: Any] {
                    var toReturn = [UBSASymbol]();
                    for (key, value) in snapshotDict {
                        if let valueString = value as? String {
                            toReturn.append(UBSASymbol(identifier: key, defaultValue: valueString));
                        } else {
                            continue;
                        }
                    }
                    return callback(toReturn); // Success condition
                } else {
                    return callback(nil);
                }
            } else {
                return callback(nil);
            }
        }
    }
}

public struct UBSASymbol {
    public var identifier: String;
    public var value: String {
        get {
            if let storedValue = computedValue {
                return storedValue;
            } else {
                return defaultValue;
            }
        }
    };
    private var computedValue: String?;
    public var defaultValue: String;
    
    public func render(templateString: String) -> String {
        return templateString.replacingOccurrences(of: "$(\(identifier))", with: value);
    }
    
    public func matches(symbolString: String) -> Bool {
        return identifier == symbolString;
    }
    
    public init(identifier: String, defaultValue: String) {
        self.defaultValue = defaultValue;
        self.identifier = identifier;
    }
}
