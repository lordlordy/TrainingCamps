//
//  CampAthleteListSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 24/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class CampAthleteListSplitViewController: CampSplitViewController, RankingsViewControllerProtocol{
    
    
    func setRankings(_ rankings: Rankable) {
        for c in children{
            if let r = c as? RankingsViewControllerProtocol{
                r.setRankings(rankings)
            }
        }
    }
    
}
