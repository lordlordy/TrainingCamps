//
//  RaceDefinitionListViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class RaceDefinitionListViewController: CampGroupViewController, NSTableViewDelegate, NSComboBoxDataSource{
    
    
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
    
    //MARK: - NSComboBoxDataSource   participantsOnCampComboBox
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {

        if let cg = campGroup{
            let locations = cg.locationsArray().map({$0.name ?? "Not set"})
            if locations.count > index{
                return locations[index]
            }
        }
        return nil
    }
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return campGroup?.locationsArray().count ?? 0
    }
    
}
