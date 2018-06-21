//
//  CampParticipantSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampParticipantSplitViewController: NSSplitViewController, CampParticipantViewControllerProtocol{
    
    func setCampParticipant(_ campParticipant: CampParticipant) {
        for c in childViewControllers{
            if let vc = c as? CampParticipantViewControllerProtocol{
                vc.setCampParticipant(campParticipant)
            }
        }
    }
    
}
