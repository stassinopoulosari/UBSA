//
//  StyledNavigationController.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/8/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit
import UBSAKit

/**
 Navigation controller with extra UI methods
 */
class StyledNavigationController: UINavigationController {
    
    
    //MARK: - View functions
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.backgroundColor = AppConfig.C.colour;
    }
    
    
    
    override public func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(animated);
        print("Viewdidappear beginning in navi")
        UIView.animate(withDuration: 0.5) {
            self.navigationBar.backgroundColor = AppConfig.C.colour;
            self.navigationBar.tintColor = AppConfig.C.textColour;
            self.navigationBar.barTintColor = AppConfig.C.colour;
        }
        
    }
    
    // MARK: - Colours
    
    ///Sets preferred status bar style to light or dark depending on background
    override public  var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            
            return AppConfig.C.textColour == .white ? .lightContent : .default;
        }
    }
    
    ///Does the navigation bar have a background (is it invisible)?
    public var hasBackground: Bool {
        get {
            return self.navigationBar.shadowImage != nil; // I guess I need a getter 🤷‍♂️
        }
    }
    
    public func setHasBackground(_ hasBackground: Bool, completion callback: (() -> Void)?) {
        UIView.transition(with: self.navigationBar, duration: 0.5, options: [.transitionCrossDissolve, .allowAnimatedContent], animations: {
            if(!hasBackground) { // If false
                self.navigationBar.shadowImage = UIImage(); // Disappear shadow
                self.navigationBar.setBackgroundImage(UIImage(), for: .default); // Disappear background
                self.navigationBar.isTranslucent = true; // Set translucent
            } else {
                //self.navigationBar.shadowImage = nil; // Appear shadow
                self.navigationBar.setBackgroundImage(nil, for: .default) // Appear background
                //self.navigationBar.isTranslucent = false; // Bar no longer translucent*/
            }
        }, completion: { _ in
            if let cb = callback {
                cb();
            }
            });
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /**
     Prepare for segue
     
     - See ViewController
     */
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}
