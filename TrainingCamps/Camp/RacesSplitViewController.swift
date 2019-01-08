//
//  RacesSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 06/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class RacesSplitViewController: NSSplitViewController, CampViewControllerProtocol, RaceViewControllerProtocol, RankingsViewControllerProtocol{
    
    func setCamp(_ camp: Camp) {
        for c in children{
            if let vc = c as? CampViewControllerProtocol{
                vc.setCamp(camp)
            }
        }
    }
    
    func setRace(_ race: Race) {
        for c in children{
            if let r = c as? RaceViewControllerProtocol{
                r.setRace(race)
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
