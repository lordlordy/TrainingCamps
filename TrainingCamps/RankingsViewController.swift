//
//  RankingsViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 24/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class RankingsViewController: NSViewController, RankingsViewControllerProtocol{
    
    @objc dynamic var ranks: Rankable?
    
    func setRankings(_ rankings: Rankable){
        ranks = rankings
    }
    
}
