//
//  RaceResultsSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 24/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class RaceResultsSplitViewController: NSSplitViewController, RaceResultsViewControllerProtocol, RankingsViewControllerProtocol{
    
    
    func setRaceResults(_ raceResults: NSSet) {
        for c in childViewControllers{
            if let vc = c as? RaceResultsViewControllerProtocol{
                vc.setRaceResults(raceResults)
            }
        }
    }
    
    func setRankings(_ rankings: Rankable) {
        for c in childViewControllers{
            if let vc = c as? RankingsViewControllerProtocol{
                vc.setRankings(rankings)
            }
        }
    }
    
}
