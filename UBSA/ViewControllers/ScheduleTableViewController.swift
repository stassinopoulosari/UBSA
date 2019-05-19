//
//  ScheduleTableViewController.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/15/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit
import UBSAKit

class ScheduleTableViewController: UITableViewController {
    
    public var currentSchedule: UBSASchedule?;
    public var currentSymbols: UBSASymbols?;
    public var currentCalendar: UBSACalendar?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        print("Table loaded succ");
        
        sortData();
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let schedule = currentSchedule {
            return schedule.periods.count;
        } else {
            return 1;
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        
        if let classCell = cell as? ScheduleClassCell, let schedule = currentSchedule, let symbols = currentSymbols {
            if(schedule.periods.count > indexPath.row) {
                let period = schedule.periods[indexPath.row];
                let label = period.name;
                let startEndLabelText = "\(period.startTimeDisplay) - \(period.endTimeDisplay)";
                let labelText = symbols.render(templateString: label);
                classCell.startAndEndField.text = startEndLabelText;
                classCell.labelField.text = labelText;
                if(schedule.getPeriod(fromDate: Date()) != nil && schedule.getPeriod(fromDate: Date())! == period) {
                    classCell.boldText();
                } else {
                    classCell.normalText();
                }
                cell = classCell;
            }
            // Configure the cell...
        } else if let classCell = cell as? ScheduleClassCell {
            classCell.startAndEndField.text = "";
            classCell.labelField.text = "";
            classCell.fallbackField.text = "No schedule was found for today.";
        }
        return cell;
    }
    
    private func sortData() {
        if var schedule = currentSchedule {
            schedule.periods.sort { (a, b) -> Bool in
                let hrComp = a.startTimeComponents.0 - b.startTimeComponents.0;
                let minComp = a.startTimeComponents.1 - b.startTimeComponents.1;
                
                if(hrComp == 0) {
                    return minComp < 0;
                }
                
                return hrComp < 0;
            }
            currentSchedule = schedule;
        } else {
            return;
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(ScheduleClassCell.HEIGHT_NORMAL);
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AllSchedulesTableViewController, let calendar = currentCalendar, let symbols = currentSymbols {
            destination.currentScheduleTable = calendar.scheduleTable;
            destination.currentSymbols = symbols;
        }
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
 
    @IBAction func allSchedulesButtonClicked(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "todaysScheduleToAllSchedulesSegue", sender: nil);
    }
    
}

