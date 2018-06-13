//
//  ParticipantListViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 13/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class ParticipantListViewController: CampGroupViewController{
    
    @IBAction func filterOnUniqueName(_ sender: NSTextField) {
        if let p = parent as? ParticipantsSplitViewController{
            p.filter(forName: sender.stringValue)
        }
    }
    
}
