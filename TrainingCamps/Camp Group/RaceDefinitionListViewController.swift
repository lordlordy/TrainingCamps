//
//  RaceDefinitionListViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class RaceDefinitionListViewController: CampGroupViewController, NSTableViewDelegate{
    
    
    @IBOutlet var raceDefinitionsAC: NSArrayController!
    
    //MARK: - NSTableViewDelegate
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let rd = getSelectedRaceDefinition(){
            if let p = parent?.parent as? RaceDefinitionViewControllerProtocol{
                p.setRaceDefinition(rd)
            }
        }
    }
    
    
    private func getSelectedRaceDefinition() -> RaceDefinition?{
        if let definitions = raceDefinitionsAC.selectedObjects as? [RaceDefinition]{
            if definitions.count > 0{
                return definitions[0]
            }
        }
        return nil
    }
    
}
