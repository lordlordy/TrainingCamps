//
//  CampParticipantsSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 15/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampParticipantsSplitViewController: NSSplitViewController, CampViewControllerProtocol, CampParticipantViewControllerProtocol, RaceResultsViewControllerProtocol{
    
    
    func setCamp(_ camp: Camp) {
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
    
    func setRaceResults(_ raceResults: NSSet) {
        for c in childViewControllers{
            if let vc = c as? RaceResultsViewControllerProtocol{
                vc.setRaceResults(raceResults)
            }
        }
    }
    
}
