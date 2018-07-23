//
//  TrainingDataViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 19/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class TrainingDataViewController: NSViewController, NSTableViewDelegate{
    
    @IBOutlet var arrayController: NSArrayController!
    @objc dynamic var data: [TrainingDataProtocol] = []
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let p = parent?.parent as? TrainingDistributionViewController{
            if let selection = arrayController.selectedObjects as? [TrainingDataProtocol]{
                p.set(selection: selection)
            }

        }
    }
    
    func filter(forParticipant p: String){
        if p == ""{
            arrayController.filterPredicate = nil
        }else{
            arrayController.filterPredicate = NSPredicate(format: "participantName CONTAINS %@", argumentArray: [p])
        }
    }
    
}
