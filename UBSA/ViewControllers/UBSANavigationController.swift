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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.backgroundColor = UBSAAppConfig.c.colour;
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UBSAAppConfig.c.textColour == .white ? .lightContent : .default;
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        UIView.animate(withDuration: 0.5) {
            self.navigationBar.backgroundColor = UBSAAppConfig.c.colour;
            self.navigationBar.tintColor = UBSAAppConfig.c.textColour;
            self.navigationBar.barTintColor = UBSAAppConfig.c.colour;
        }
        
        

    }
    
    public var hasBackground: Bool {
        set {
            if(!newValue) {
                self.navigationBar.shadowImage = UIImage();
                self.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.navigationBar.isTranslucent = true;
            } else {
                self.navigationBar.shadowImage = nil;
                self.navigationBar.setBackgroundImage(nil, for: .default)
                self.navigationBar.isTranslucent = false;
            }
        } get {
            return self.navigationBar.shadowImage != nil;
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
