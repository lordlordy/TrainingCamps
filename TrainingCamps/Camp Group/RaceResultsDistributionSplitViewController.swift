//
//  RaceResultsDistributionSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 17/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class RaceResultsDistributionSplitViewController: NSSplitViewController, RaceDefinitionViewControllerProtocol, CampGroupViewControllerProtocol{
    
    func setCampGroup(_ campGroup: CampGroup) {
        for c in children{
            if let vc = c as? CampGroupViewControllerProtocol{
                vc.setCampGroup(campGroup)
            }
        }
    }
    
    
    func setRaceDefinition(_ raceDefinition: RaceDefinition) {
        for c in children{
            if let vc = c as? RaceResultsViewControllerProtocol{
                vc.setRaceResults(raceDefinition.allRaceResults)
            }
        }
    }
    
    func setHighlightedValue(_ v: [Double]){
        for c in children{
            for child in c.children{
                if let graph = child as? RaceResultsGraphViewController{
                    graph.setHighlightedValue(v)
                }
            }
        }
        
    }
    
    
}

