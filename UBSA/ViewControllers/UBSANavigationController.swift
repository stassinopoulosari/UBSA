//
//  UBSANavigationController.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/8/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit
import UBSAKit

class UBSANavigationController: UINavigationController {

    ///View did load: changes navigation bar background colour
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.backgroundColor = UBSAAppConfig.c.colour;
    }
    
    ///Sets preferred status bar style to light or dark depending on background
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UBSAAppConfig.c.textColour == .white ? .lightContent : .default;
        }
    }
    
    ///ViewDidAppear: set background, tint colours
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        UIView.animate(withDuration: 0.5) {
            self.navigationBar.backgroundColor = UBSAAppConfig.c.colour;
            self.navigationBar.tintColor = UBSAAppConfig.c.textColour;
            self.navigationBar.barTintColor = UBSAAppConfig.c.colour;
        }
    }
    
    ///Does the navigation bar have a background (is it invisible)?
    public var hasBackground: Bool {
        set {
            if(!newValue) { // If false
                self.navigationBar.shadowImage = UIImage(); // Disappear shadow
                self.navigationBar.setBackgroundImage(UIImage(), for: .default); // Disappear background
                self.navigationBar.isTranslucent = true; // Set translucent
            } else {
                self.navigationBar.shadowImage = nil; // Appear shadow
                self.navigationBar.setBackgroundImage(nil, for: .default) // Appear background
                self.navigationBar.isTranslucent = false; // Bar no longer translucent
            }
        } get {
            return self.navigationBar.shadowImage != nil; // I guess I need a getter 🤷‍♂️
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
