//
//  RaceDefinitionDescriptionsViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 22/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class RaceDefinitionDescriptionsViewController: NSViewController, RaceDefinitionViewControllerProtocol{
    
    @objc dynamic var raceDefinition: RaceDefinition?

    func setRaceDefinition(_ raceDefinition: RaceDefinition) {
        self.raceDefinition = raceDefinition
    }
    

    
}
