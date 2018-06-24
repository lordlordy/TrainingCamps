//
//  ParticipantCampDaysViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 19/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class ParticipantCampDaysViewController: NSViewController, NSComboBoxDataSource, DayViewControllerProtocol, NSTableViewDelegate{
    
    @objc dynamic var day: Day?
    @IBOutlet var daysAC: NSArrayController!
    
    func setDay(_ day: Day) {
        self.day = day
    }
    
    @IBAction func selectParticipant(_ sender: NSComboBox) {
        let name: String = sender.stringValue
        if let c = day?.camp{
                if c.isOnCamp(displayName: name){
                    daysAC.filterPredicate = NSPredicate(format: "displayName CONTAINS %@", argumentArray: [name])
                }else{
                    daysAC.filterPredicate = nil
                    sender.stringValue = ""
                }
            
 
        }
    }
    
    //MARK: - NSTableViewDelegate
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let selection = daysAC.selectedObjects as? [ParticipantDay]{
            if selection.count > 0{
                if let p = parent as? RankingsViewControllerProtocol{
                    p.setRankings(selection[0])
                }
            }
        }
    }
    
    //MARK: - NSComboBoxDataSource
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {

        if let participants = day?.camp?.campParticipantDisplayNames(){
            if index < participants.count{
                return participants[index]
            }
        }

        return nil
    }
    
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return day?.camp?.campParticipantDisplayNames().count ?? 0
    }
    
}
