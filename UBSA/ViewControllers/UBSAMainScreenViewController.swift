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
    @IBOutlet var startTimeLabel: UBSAMainScreenLabel!;
    @IBOutlet var activityIndicator: UIActivityIndicatorView!;
    @IBOutlet var countdownLabel: UILabel!
    
    var currentSchedule: UBSASchedule?;
    var currentSymbols: UBSASymbols?;
    var periodTimer: Timer?;
    
    func startTimer() {
        if(periodTimer == nil) {
            periodTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                DispatchQueue.main.async { [weak self] in
                    if(self == nil) { return; }
                    self!.displayPeriod();
                }
            });
            if let timer = periodTimer {
                timer.fire();
            }
        }
    }
    
    ///ViewDidLoad overrider, sets navigation controller colour
    override public func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = UBSAAppConfig.sharedContext.colour;
        
        self.hideTextFields();
        self.showActivityIndicator();
        
        if let navigationController = self.navigationController { // Check if navi controller exists
            if let ubsaNavigationController = navigationController as? UBSANavigationController{ // Make sure navi controller is a custom one
                ubsaNavigationController.setHasBackground(false, completion: nil); // Disappear background of navi controller.
            }
        }
        
        loadTodaySchedule(UBSAAppConfig.sharedContext);
        
        startTimer();
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("Before startTimer");
        
        startTimer();
        
        print("After start timer, before try navi set")
        
        if let navigationController = self.navigationController { // Check if navi controller exists
            if let ubsaNavigationController = navigationController as? UBSANavigationController{ // Make sure navi controller is a custom one
                ubsaNavigationController.setHasBackground(false, completion: nil); // Disappear background of navi controller.
            }
        }
        
        print("After naviset, success")
        
    }
    
    func hideTextFields() {
        [endTimeLabel, startTimeLabel, countdownLabel].forEach { (label) in
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
        UIView.animate(withDuration: 0.5, animations: {
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
        if(!view.isHidden) {
            if let callback = callbackO {
                return DispatchQueue.main.async {
                    callback();
                }
            }
            return;
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
            if let currentPeriod = schedule.getPeriod(fromDate: Date()) {
                let distanceFromEnd = currentPeriod.distanceFromEnd(date: Date().addingTimeInterval(2));
                if(distanceFromEnd <= 60) {
                    self.countdownLabel.text = "\(Int(distanceFromEnd) / 60):\(Int(distanceFromEnd) % 60 < 10 ? "0\(Int(distanceFromEnd) % 60)" : "\(Int(distanceFromEnd) % 60)")";
                    self.fadeIn(self.countdownLabel, completion: nil);
                } else {
                    self.countdownLabel.text = "";
                    self.fadeOut(self.countdownLabel, completion: nil);
                }
            }
            hideActivityIndicator { [weak self] in
                if let this = self {
                    let currentDate = Date();
                    if let currentPeriod = schedule.getPeriod(fromDate: currentDate) {
                        if let symbols = this.currentSymbols {

                            this.startTimeLabel.text = currentPeriod.startTimeDisplay;
                            this.endTimeLabel.text = currentPeriod.endTimeDisplay;
                            this.navigationItem.title = symbols.render(templateString: currentPeriod.name);

                        }
                    } else {
                        this.startTimeLabel.text = "";
                        this.endTimeLabel.text = "No class";
                        this.navigationItem.title = "";
                    }
                    this.fadeIn(this.endTimeLabel, completion: nil);
                    this.fadeIn(this.startTimeLabel, completion: nil);

                }
            }
        }
    }
    
    func loadTodaySchedule(_ c: UBSAContext) {
        let calendarRef = UBSACalendar.calendarPath(c, fromDate: Date());
        UBSASymbols.makeSymbols(fromReference: UBSASymbols.symbolPath(c)) { (symbolsO) in
            if let symbols = symbolsO {
                self.currentSymbols = symbols;
                UBSAScheduleTable.makeScheduleTable(c, withReference: UBSAScheduleTable.scheduleTablePath(c)) { (scheduleTable_) in
                    if let scheduleTable = scheduleTable_ {
                        UBSACalendar.makeCalendar(withReference: calendarRef, scheduleTable: scheduleTable) { (calendar_) in
                            if let calendar = calendar_ {
                                if let todaySchedule = calendar.getSchedule(forDay: UBSACalendar.day(fromDate: Date())) {
                                    self.currentSchedule = todaySchedule;
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
            } else {
                return;
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(periodTimer != nil) {
            periodTimer!.invalidate();
            periodTimer = nil;
        }
        self.navigationItem.title = "Home";
    }
    
    @IBAction func onScheduleButtonpressed(_ sender: UIBarButtonItem) {
        if let navigationBar = self.navigationController as? UBSANavigationController {
            navigationBar.setHasBackground(true) {
            self.performSegue(withIdentifier: "homeScreenToScheduleSegue", sender: nil);
            }
        }
    }
    
    
}
