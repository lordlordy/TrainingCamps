//
//  CampParticipantSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampParticipantSplitViewController: NSSplitViewController, RaceResultsViewControllerProtocol, CampParticipantViewControllerProtocol, RankingsViewControllerProtocol{
    
    func setRaceResults(_ raceResults: NSSet) {
        for c in children{
            if let vc = c as? RaceResultsViewControllerProtocol{
                vc.setRaceResults(raceResults)
            }
        }
    }
    
    func setCampParticipant(_ campParticipant: CampParticipant) {
        for c in children{
            if let vc = c as? CampParticipantViewControllerProtocol{
                vc.setCampParticipant(campParticipant)
            }
        }
    }
    
    
    func setRankings(_ rankings: Rankable) {
        for c in children{
            if let vc = c as? RankingsViewControllerProtocol{
                vc.setRankings(rankings)
            }
        }
    }

    
    
}
