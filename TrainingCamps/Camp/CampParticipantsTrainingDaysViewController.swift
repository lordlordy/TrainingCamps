//
//  CampParticipantsTrainingDaysViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 18/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampParticipantsTrainingDaysViewController: NSViewController, CampParticipantViewControllerProtocol, NSComboBoxDataSource, NSTableViewDelegate {
    
    @objc dynamic var campParticipant: CampParticipant?
    @IBOutlet var participantDaysAC: NSArrayController!
    
    func setCampParticipant(_ campParticipant: CampParticipant) {
        self.campParticipant = campParticipant
    }
    
    //MARK: - NSComboBoxDataSource
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {

        let df: DateFormatter = DateFormatter()
        df.dateFormat =  DateFormatString.ValidCampDate.rawValue

        if let dateStrings: [String] = campParticipant?.camp?.validDates().map({df.string(from: $0)}){
            if index < dateStrings.count{
                return dateStrings[index]
            }
        }
        return nil
        
    }
    
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return campParticipant?.camp?.validDates().count ?? 0
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let selection = participantDaysAC.selectedObjects as? [ParticipantDay]{
            if let p = parent as? RankingsViewControllerProtocol{
                p.setRankings(selection[0])
            }
        }
    }
    

    
}
