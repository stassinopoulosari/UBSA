//
//  SymbolCell.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/18/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit
import UBSAKit;

class SymbolCell: UITableViewCell {
    
    @IBOutlet var textField: UITextField!;
    
    public var symbol: UBSASymbol?;
    
    public func render() {
        if let symbol = self.symbol {
            self.textField.placeholder = symbol.defaultValue;
            if let configuredValue = symbol.configuredValue {
                self.textField.text = configuredValue;
            } else {
                self.textField.text = "";
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.addTarget(self, action: #selector(onUpdate), for: .allEvents);
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc func onUpdate() {
        if var symbol = self.symbol {
            if let text = textField.text {
                if(text == "") {
                    symbol.configuredValue = nil;
                    return;
                }
                symbol.configuredValue = text;
            } else {
                symbol.configuredValue = nil;
            }
            self.symbol = symbol;
        }
    }
    
    
    
}
