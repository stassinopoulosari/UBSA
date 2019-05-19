//
//  ScheduleTableViewController.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/15/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit
import UBSAKit

class AllSchedulesTableViewController: UITableViewController {
    
    public var currentSymbols: UBSASymbols?;
    public var currentScheduleTable: UBSASchedules?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        print("Table loaded succ");
        
        //loadData();
        sortData();
    }
    
    // MARK: - Table view data source
    
    func loadData() {
        UBSASchedules.makeScheduleTable(AppConfig.C, withReference: UBSASchedules.scheduleTablePath(AppConfig.C)) { (scheduleTableO) in
            if let scheduleTable = scheduleTableO {
                self.currentScheduleTable = scheduleTable;
                self.sortData();
                self.tableView?.reloadData();
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let scheduleTable = currentScheduleTable {
            return scheduleTable.schedules.filter({ arg0 -> Bool in
                let (_, v) = arg0;
                return !v.hidden;
            }).count;
        }
        return 0;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if var scheduleTable = currentScheduleTable {
            scheduleTable.schedules = scheduleTable.schedules.filter { arg0 -> Bool in
                let (_, v) = arg0;
                return !v.hidden;
            };
            let keys = Array(scheduleTable.schedules.keys).sorted(by: <);
            if let schedule = scheduleTable.schedules[keys[section]] {
                return schedule.periods.count;
            }
            return 0;
        }
        return 0;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        
        if let classCell = cell as? ScheduleClassCell, var scheduleTable = currentScheduleTable, let symbols = currentSymbols {
            
            scheduleTable.schedules =  scheduleTable.schedules.filter({ arg0 -> Bool in
                let (_, v) = arg0;
                return !v.hidden;
            });
            
            let keys = Array(scheduleTable.schedules.keys).sorted(by: <);
            let section = indexPath.section;
            let scheduleO =  scheduleTable.schedules[keys[section]];
            
            if let schedule = scheduleO {
                if(schedule.periods.count > indexPath.row) {
                    let period = schedule.periods[indexPath.row];
                    let label = period.name;
                    let startEndLabelText = "\(period.startTimeDisplay) - \(period.endTimeDisplay)";
                    let labelText = symbols.render(templateString: label);
                    classCell.startAndEndField.text = startEndLabelText;
                    classCell.labelField.text = labelText;
                    /*if(schedule.getPeriod(fromDate: Date()) != nil && schedule.getPeriod(fromDate: Date())! == period) {
                     classCell.boldText();
                     } else {*/
                    classCell.normalText();
                    //}
                    cell = classCell;
                }
            }
            // Configure the cell...
        }
        return cell;
    }
    
    private func sortData() {
        if var scheduleTable = currentScheduleTable {
            for (key, schedule) in scheduleTable.schedules {
                var sked = schedule;
                sked.periods.sort { (a, b) -> Bool in
                    let hrComp = a.startTimeComponents.0 - b.startTimeComponents.0;
                    let minComp = a.startTimeComponents.1 - b.startTimeComponents.1;
                    
                    if(hrComp == 0) {
                        return minComp < 0;
                    }
                    
                    return hrComp < 0;
                }
                scheduleTable.schedules[key] = sked;
            }
            currentScheduleTable = scheduleTable;
        } else {
            return;
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if var scheduleTable = currentScheduleTable {
            scheduleTable.schedules = scheduleTable.schedules.filter({ arg0 -> Bool in
                let (_, v) = arg0;
                return !v.hidden;
            });
            let keys = Array(scheduleTable.schedules.keys).sorted(by: <);
            let sectionN = keys[section];
            if let schedule = scheduleTable.schedules[sectionN] {
                return schedule.name;
            }
        }
        return "";
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(ScheduleClassCell.HEIGHT_NORMAL);
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

