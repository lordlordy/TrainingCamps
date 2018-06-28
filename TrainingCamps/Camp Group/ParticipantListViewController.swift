//
//  ParticipantListViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 13/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class ParticipantListViewController: CampGroupViewController, NSTableViewDelegate{
    
    @IBOutlet var participantsAC: NSArrayController!
    
    @IBAction func filterOnUniqueName(_ sender: NSTextField) {
        let name: String = sender.stringValue
        if let pac = participantsAC{
            if name == ""{
                pac.filterPredicate = nil
            }else{
                pac.filterPredicate = NSPredicate.init(format: "uniqueName CONTAINS %@", argumentArray: [name])
            }
        }
    }
    
//    @IBAction func addParticipant(_ sender: Any){
//        if let p = parent as? ParticipantsSplitViewController{
//            if let pac = p.participantsAC{
//                pac.add(sender)
//            }
//        }
//    }
    
//    @IBAction func removeParticipant(_ sender: Any){
//        if let p = parent as? ParticipantsSplitViewController{
//            if let pac = p.participantsAC{
//                pac.remove(sender)
//            }
//        }
//    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let p = parent as? ParticipantsSplitViewController{
            p.setParticipants(participantsAC.selectedObjects as? [Participant] ?? [])
        }
    }
    
//    private func selectedParticipant() -> Participant?{
//        if let selection = participantsAC.selectedObjects as? [Participant]{
//            if selection.count > 0{
//                return selection[0]
//            }
//        }
//        return nil
//    }
    
}
