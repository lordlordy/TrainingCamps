//
//  CampDaySplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 24/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampDaySplitViewController: NSSplitViewController, DayViewControllerProtocol, RankingsViewControllerProtocol{
    
    
    func setDay(_ day: Day) {
        for c in childViewControllers{
            if let vc = c as? DayViewControllerProtocol{
                vc.setDay(day)
            }
        }
    }
    
    func setRankings(_ ranks: Rankable){
        for c in childViewControllers{
            if let rvcp = c as? RankingsViewControllerProtocol{
                rvcp.setRankings(ranks)
            }
        }
    }
    
}
