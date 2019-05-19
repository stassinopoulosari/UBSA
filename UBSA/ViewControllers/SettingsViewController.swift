//
//  UBSASettingsTableViewController.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/18/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit
import UBSAKit;

class SettingsViewController: UITableViewController {

    public var currentSymbols: UBSASymbols?;
    
    @IBOutlet var infoButton: UIButton!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoButton.setTitle("About \(AppConfig.C.config.appName)", for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassNameTableViewController {
            destination.currentSymbols = currentSymbols;
        }
    }
    

}
