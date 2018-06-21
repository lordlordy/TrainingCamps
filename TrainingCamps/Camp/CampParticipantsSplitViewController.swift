//
//  CampParticipantsSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 15/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampParticipantsSplitViewController: NSSplitViewController, CampViewControllerProtocol, CampParticipantViewControllerProtocol{
    
//    @objc dynamic var camp: Camp?
//    @IBOutlet var campParticipantsAC: NSArrayController!
//    @IBOutlet var participantDaysAC: NSArrayController!
//    @IBOutlet var raceResultsAC: NSArrayController!
    
    func setCamp(_ camp: Camp) {
//        self.camp = camp
        for child in childViewControllers{
            if let c = child as? CampViewControllerProtocol{
                c.setCamp(camp)
            }
        }
    }
    
    func setCampParticipant(_ campParticipant: CampParticipant) {
        for c in childViewControllers{
            if let vc = c as? CampParticipantViewControllerProtocol{
                vc.setCampParticipant(campParticipant)
            }
        }
    }
    
}
