//
//  UBSAMainScreenViewController.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/8/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit;
import UBSAKit;

/**
 Main screen of the app: the classic Bell Schedule view
 */
class UBSAMainScreenViewController: UIViewController {
    
    @IBOutlet var endTimeLabel: UBSAMainScreenLabel!;
    @IBOutlet var classNameLabel: UBSAMainScreenLabel!;
    @IBOutlet var startTimeLabel: UBSAMainScreenLabel!;
    @IBOutlet var activityIndicator: UIActivityIndicatorView!;
    
    var currentSchedule: UBSASchedule?;
    var periodTimer: Timer?;
    
    ///ViewDidLoad overrider, sets navigation controller colour
    override public func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = UBSAAppConfig.sharedContext.colour;
        self.hideTextFields();
        self.showActivityIndicator();
        if let navigationController = self.navigationController { // Check if navi controller exists
            if let ubsaNavigationController = navigationController as? UBSANavigationController{ // Make sure navi controller is a custom one
                ubsaNavigationController.hasBackground = false; // Disappear background of navi controller.
            }
        }
        
        loadTodaySchedule(UBSAAppConfig.sharedContext);
        
        periodTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { (_) in
            DispatchQueue.main.async {
                self.displayPeriod();
            }
        })
        
    }
    
    func hideTextFields() {
        [endTimeLabel, classNameLabel, startTimeLabel].forEach { (label) in
            if let labelRef = label {
                labelRef.isHidden = true;
            }
        }
    }
    
    func showActivityIndicator() {
        activityIndicator.style = UBSAAppConfig.sharedContext.textColour == .white ? .white : .gray;
        activityIndicator.startAnimating();
    }
    
    func hideActivityIndicator(completion callback: @escaping () -> Void) {
        if(activityIndicator.isHidden && !activityIndicator.isAnimating) {
            return DispatchQueue.main.async {
                callback();
            }
        }
        UIView.animate(withDuration: 1.0, animations: {
            self.activityIndicator.alpha = 0.0;
        }) { _ in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true;
            return DispatchQueue.main.async {
                callback();
            }
        }
    }
    
    func fadeIn(_ view: UIView, completion callbackO: (() -> Void)?) {
        if let callback = callbackO {
            return DispatchQueue.main.async {
                callback();
            }
        }
        view.alpha = 0;
        view.isHidden = false;
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 1.0;
        }, completion: {_ in
            if let callback = callbackO {
                return DispatchQueue.main.async {
                    callback();
                }
            }
        });
    }
    
    func fadeOut(_ view: UIView, completion callbackO: (() -> Void)?) {
        if(view.alpha == 0.0 && view.isHidden) {
            if let callback = callbackO {
                return DispatchQueue.main.async {
                    callback();
                }
            }
            return;
        }
        view.alpha = 1.0;
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 0.0;
        }, completion: { _ in
            view.isHidden = true;
            if let callback = callbackO {
                DispatchQueue.main.async {
                callback();
                }
            }
        });
    }
    
    func displayPeriod() {
        if let schedule = currentSchedule {
            hideActivityIndicator {
                if let currentPeriod = schedule.getPeriod(fromDate: Date()) {
                    self.startTimeLabel.text = currentPeriod.startTimeDisplay;
                    self.endTimeLabel.text = currentPeriod.endTimeDisplay;
                } else {
                    self.startTimeLabel.text = "";
                    self.endTimeLabel.text = "No class";
                }
                self.fadeIn(self.endTimeLabel, completion: nil);
                self.fadeIn(self.startTimeLabel, completion: nil);
            }
        }
    }
    
    func loadTodaySchedule(_ c: UBSAContext) {
        let calendarRef = UBSACalendar.calendarPath(c, fromDate: Date());
        UBSAScheduleTable.makeScheduleTable(c, withReference: UBSAScheduleTable.scheduleTablePath(c)) { (scheduleTable_) in
            if let scheduleTable = scheduleTable_ {
                UBSACalendar.makeCalendar(withReference: calendarRef, scheduleTable: scheduleTable) { (calendar_) in
                    if let calendar = calendar_ {
                        if let todaySchedule = calendar.getSchedule(forDay: UBSACalendar.day(fromDate: Date())) {
                            self.currentSchedule = todaySchedule;
                            print(todaySchedule.name);
                            self.displayPeriod();
                        }
                    } else {
                        return;
                    }
                };
            } else {
                return;
            }
        }
    }
    
}
