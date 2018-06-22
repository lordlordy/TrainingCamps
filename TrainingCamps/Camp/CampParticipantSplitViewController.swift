//
//  CampParticipantSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampParticipantSplitViewController: NSSplitViewController, RaceResultsViewControllerProtocol, CampParticipantViewControllerProtocol{
    
    func setRaceResults(_ raceResults: NSSet) {
        for c in childViewControllers{
            if let vc = c as? RaceResultsViewControllerProtocol{
                vc.setRaceResults(raceResults)
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
