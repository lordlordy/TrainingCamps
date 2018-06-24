//
//  CampParticipantsListViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 17/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampParticipantsListViewController: CampViewController, NSComboBoxDataSource, NSTableViewDelegate{
  
    
    @IBOutlet var campParticipantAC: NSArrayController!
    
    @IBAction func rankCompetition(_ sender: Any){
        if let c = camp{
            c.rankCompetition()
        }
    }
    
    @IBAction func rank(_ sender: Any) {
        let start = Date()
        camp?.campGroup?.rank()
        print("Ranking took \(Date().timeIntervalSince(start))s")
    }
    
    //MARK: - NSTableViewDelegate
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let cp = getSelectedParticipant(){
            if let vc = parent as? RaceResultsViewControllerProtocol{
                vc.setRaceResults(cp.raceResults ?? NSSet())
            }
            if let vc = parent as? CampParticipantViewControllerProtocol{
                vc.setCampParticipant(cp)
            }
        }
    }

    @IBAction func selectedParticipant(_ sender: NSComboBox) {
        let name: String = sender.stringValue
        if let c = camp{
            if c.isOnCamp(displayName: name){
                campParticipantAC.filterPredicate = NSPredicate(format: "participant.displayName CONTAINS %@", argumentArray: [name])
                campParticipantAC.setSelectionIndex(0)
            }else{
                campParticipantAC.filterPredicate = nil
                sender.stringValue = ""
            }
        }
    }
    
    //MARK: - NSComboBoxDataSource   participantsOnCampComboBox
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "CampParticipantComboBox":
                let participants = getParticipantsNotYetIncludedInCamp()
                if index < participants.count{
                    return participants[index]
                }
            case "participantsOnCampComboBox":
                let participants = camp?.campParticipantDisplayNames() ?? []
                if index < participants.count{
                    return participants[index]
                }
            default:
                print("What combo box is this \(identifier.rawValue) which I'm (CampParticipantsListViewController) a data source for? ")
            }
        }
        return nil
    }
    
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "CampParticipantComboBox":
                return getParticipantsNotYetIncludedInCamp().count
            case "participantsOnCampComboBox":
                return camp?.campParticipantUniqueNames().count ?? 0
            default:
                return 0
            }
        }
        return 0
    }
    
    private func getParticipantsNotYetIncludedInCamp() -> [String]{
        var result: [String] = []
        if let a = camp{
            if let cg = a.campGroup{
                let allP = cg.participantArray().map({$0.displayName})
                let campP = a.campParticipantsArray().map({$0.participant?.displayName ?? "Not set"})
                for p in allP{
                    if !campP.contains(p){
                        result.append(p)
                    }
                }
            }
        }
        return result.sorted(by: {$0 < $1})
    }
    
    private func getSelectedParticipant() -> CampParticipant?{
        if let selection = campParticipantAC.selectedObjects as? [CampParticipant]{
            if selection.count > 0{
                return selection[0]
            }
        }
        return nil
    }
    
}
