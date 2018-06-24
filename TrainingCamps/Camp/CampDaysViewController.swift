//
//  CampDaysViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 19/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampDaysViewController: CampViewController, NSComboBoxDataSource, NSTableViewDelegate{
    
    @IBOutlet var daysAC: NSArrayController!
    
//    @IBAction func rank(_ sender: Any) {
//        let start = Date()
//        camp?.campGroup?.rank()
//        print("Ranking took \(Int(Date().timeIntervalSince(start)))s")
//    }
    
    
    //MARK: - NSTableViewDelegate
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let p = parent as? DayViewControllerProtocol{
            if let d = getSelectedDay(){
                p.setDay(d)
            }
        }
    }
    

    //MARK: - NSComboBoxDataSource
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        let dates = getValidDateStrings()
        if index < dates.count{
            return dates[index]
        }
                
        return nil
    }
    
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return camp?.validDates().count ?? 0
    }
    
    private func getValidDateStrings() -> [String]{
        if let c = camp{
            let df = DateFormatter()
            df.dateFormat =  DateFormatString.ValidCampDate.rawValue
            return c.validDates().map({df.string(from: $0)})
        }
        return []
    }
    
    private func getSelectedDay() -> Day?{
        if let selection = daysAC.selectedObjects as? [Day]{
            if selection.count > 0{
                return selection[0]
            }
        }
        return nil
    }
    
}
