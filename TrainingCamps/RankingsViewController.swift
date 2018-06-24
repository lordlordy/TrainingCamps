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
    
    @IBOutlet var rankingsAC: NSArrayController!
    
    func setRankings(_ rankings: Rankable){
        ranks = rankings
    }
    
    @IBAction func rank(_ sender: Any?){
        if let r = ranks{
            r.performRank()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rankingsAC.filterPredicate = NSPredicate(format: "Overall < 9999", argumentArray: nil)
    }
    
    
}
