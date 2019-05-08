//
//  UBSAMainScreenViewController.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/8/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit

class UBSAMainScreenViewController: UIViewController {

    ///ViewDidLoad overrider, sets navigation controller colour
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UBSAAppConfig.c.colour;
        if let navigationController = self.navigationController { // Check if navi controller exists
            if let ubsaNavigationController = navigationController as? UBSANavigationController{ // Make sure navi controller is a custom one
                ubsaNavigationController.hasBackground = false; // Disappear background of navi controller.
            }
        }
    }
    

}
