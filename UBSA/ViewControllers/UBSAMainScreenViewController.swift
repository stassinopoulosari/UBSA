//
//  UBSAMainScreenViewController.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/8/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit

class UBSAMainScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UBSAAppConfig.c.colour;
        if let navigationController = self.navigationController {
            if let ubsaNavigationController = navigationController as? UBSANavigationController{
                ubsaNavigationController.hasBackground = false;
            }
        }
        // Do any additional setup after loading the view.
    }
    

}
