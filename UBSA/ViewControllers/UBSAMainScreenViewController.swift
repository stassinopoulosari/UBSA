//
//  UBSAMainScreenViewController.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/8/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit

/**
 Main screen of the app: the classic Bell Schedule view
 */
public class UBSAMainScreenViewController: UIViewController {

    @IBOutlet var endTimeLabel: UBSAMainScreenLabel!
    @IBOutlet var classNameLabel: UBSAMainScreenLabel!
    @IBOutlet var startTimeLabel: UBSAMainScreenLabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    ///ViewDidLoad overrider, sets navigation controller colour
    override public func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UBSAAppConfig.c.colour;
        hideTextFields();
        showActivityIndicator();
        if let navigationController = self.navigationController { // Check if navi controller exists
            if let ubsaNavigationController = navigationController as? UBSANavigationController{ // Make sure navi controller is a custom one
                ubsaNavigationController.hasBackground = false; // Disappear background of navi controller.
            }
        }
        
    }
    
    func hideTextFields() {
        [endTimeLabel, classNameLabel, startTimeLabel].forEach { (label) in
            if let labelRef = label {
                labelRef.isHidden = true;
            }
        }
    }
    
    func showActivityIndicator() {
        activityIndicator.style = UBSAAppConfig.c.textColour == .white ? .white : .gray;
        activityIndicator.startAnimating();
    }
    
    func fadeIn(_ view: UIView, completion callbackO: (() -> Void)?) {
        view.alpha = 0;
        view.isHidden = false;
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 1.0;
        }, completion: {_ in
            if let callback = callbackO {
                callback();
            }
        });
    }
    
    func fadeOut(_ view: UIView, completion callbackO: (() -> Void)?) {
        view.alpha = 1.0;
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 0.0;
        }, completion: { _ in
            view.isHidden = true;
            if let callback = callbackO {
                callback();
            }
        });
    }
    

}
