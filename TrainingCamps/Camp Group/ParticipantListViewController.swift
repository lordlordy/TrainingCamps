//
//  ParticipantListViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 13/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class ParticipantListViewController: CampGroupViewController, NSTableViewDelegate{
    
    @IBAction func filterOnUniqueName(_ sender: NSTextField) {
        if let p = parent as? ParticipantsSplitViewController{
            p.filter(forName: sender.stringValue)
        }
    }
    
    @IBAction func addParticipant(_ sender: Any){
        if let p = parent as? ParticipantsSplitViewController{
            if let pac = p.participantsAC{
                pac.add(sender)
            }
        }
    }
    
    @IBAction func removeParticipant(_ sender: Any){
        if let p = parent as? ParticipantsSplitViewController{
            if let pac = p.participantsAC{
                pac.remove(sender)
            }
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let p = parent as? ParticipantsSplitViewController{
            p.createTree()
        }
    }
    

    
}
