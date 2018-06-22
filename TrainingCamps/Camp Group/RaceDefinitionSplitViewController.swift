//
//  RaceDefinitionSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 12/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class RaceDefinitionSplitViewController: CampGroupSplitViewController, RaceDefinitionViewControllerProtocol{
    
    func setRaceDefinition(_ raceDefinition: RaceDefinition) {
        for c in childViewControllers{
            if let vc = c as? RaceDefinitionViewControllerProtocol{
                vc.setRaceDefinition(raceDefinition)
            }
            if let vc = c as? RaceResultsViewControllerProtocol{
                vc.setRaceResults(raceDefinition.allRaceResults)
            }
            for gc in c.childViewControllers{
                if let vc = gc as? RaceDefinitionViewControllerProtocol{
                    vc.setRaceDefinition(raceDefinition)
                }
            }
        }
    }
    
    
    
    
}
