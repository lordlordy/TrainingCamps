//
//  EddingtonNumberViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 28/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class EddingtonNumberViewController: CampGroupViewController, NSComboBoxDataSource{
    
    @IBOutlet var eddingtonNumberAC: NSArrayController!
    
    @IBAction func calculateSelection(_ sender: Any) {
        if let selection = eddingtonNumberAC.selectedObjects as? [EddingtonNumber]{
            for s in selection{
                s.calculate()
            }
        }
    }
    
    //MARK: - NSComboBoxDataSource   participantsOnCampComboBox
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "activityComboBox":
                let strings: [String] = Activity.Eddington.map({$0.rawValue}).sorted()
                if index < strings.count{
                    return strings[index]
                }
            case "unitComboBox":
                let strings: [String] = Unit.Eddington.map({$0.rawValue}).sorted()
                if index < strings.count{
                    return strings[index]
                }
            default:
                print("What combo box is this \(identifier.rawValue) which I'm (EddingtonNumberViewController) a data source for? ")
            }
        }
        return nil
    }
    
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "activityComboBox":
                return Activity.Eddington.count
            case "unitComboBox":
                return Unit.Eddington.count
            default:
                return 0
            }
        }
        return 0
    }
    
}
