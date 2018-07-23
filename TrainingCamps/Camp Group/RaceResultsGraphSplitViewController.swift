//
//  RaceResultsGraphSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class RaceResultsGraphSplitViewController: RaceDefinitionSplitViewController, NormalDistributionViewControllerProtocol{
    
    func updateBuckets(forSelection selection: [DistributionSelection]) {
        for c in childViewControllers{
            if let vc = c as? NormalDistributionViewControllerProtocol{
                vc.updateBuckets(forSelection: selection)
            }
        }
    }
    
}
