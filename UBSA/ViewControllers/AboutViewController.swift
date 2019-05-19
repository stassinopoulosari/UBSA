//
//  UBSAAboutViewController.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/18/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit

class AboutViewController: UITableViewController {

    @IBOutlet var infoTextView: UITextView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.infoTextView.scrollRangeToVisible(NSMakeRange(0, 0));
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.infoTextView.scrollRangeToVisible(NSMakeRange(0, 0));
        }
    }

    

}
