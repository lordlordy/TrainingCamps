//
//  ParticipantsSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 06/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class ParticipantsSplitViewController: CampGroupSplitViewController{
    
    @IBOutlet var participantsAC: NSArrayController!
    
    @IBOutlet var participantsCampsAC: NSArrayController!
    
    func filter(forName name: String){
        if let pac = participantsAC{
            if name == ""{
                pac.filterPredicate = nil
            }else{
                pac.filterPredicate = NSPredicate.init(format: "uniqueName CONTAINS %@", argumentArray: [name])
            }
        }
    }
}
