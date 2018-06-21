//
//  CampRacesViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 19/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampRacesViewController: CampViewController, NSComboBoxDataSource, NSTableViewDelegate{
    
    @IBOutlet var racesAC: NSArrayController!
    
    //MARK: - NSComboBoxDataSource   participantsOnCampComboBox
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "raceDateComboBox":
                if let c = camp{
                    let df: DateFormatter = DateFormatter()
                    df.dateFormat =  DateFormatString.ValidCampDate.rawValue
                    let dateStrings = c.validDates().map({df.string(from: $0)})
                    if index < dateStrings.count{
                        return dateStrings[index]
                    }
                }
            case "raceDefinitionNameComboBox":
                if let c = camp{
                    let races = c.validRaceDefinitions().map({$0.name ?? "Not Set"})
                    if index < races.count{
                        return races[index]
                    }
                }
            default:
                print("What combo box is this \(identifier.rawValue) which I'm (CampRacesViewController) a data source for? ")
            }
        }
        return nil
    }
    
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "raceDateComboBox":
                return camp?.validDates().count ?? 0
            case "raceDefinitionNameComboBox":
                return camp?.validRaceDefinitions().count ?? 0
            default:
                return 0
            }
        }
        return 0
    }
    
    //MARK: - NSTableViewDelegate
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let p = parent as? RacesSplitViewController{
            if let r = selectedRace(){
                p.setRace(r)
            }
        }
    }
    
    private func selectedRace() -> Race?{
        if let selection = racesAC.selectedObjects as? [Race]{
            if selection.count > 0{
                return selection[0]
            }
        }
        return nil
    }
    
    
}
