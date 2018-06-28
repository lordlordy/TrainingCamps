//
//  CampsListViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampsListViewController: CampGroupViewController, NSTableViewDelegate, NSComboBoxDataSource{
    
    @IBOutlet var campsAC: NSArrayController!
    

    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let p = parent as? CampSplitViewController{
            let camps: [Camp] = selectedCamps()
            if camps.count > 0 {
                p.setCamp(camps[0])
                p.setTreeNodes(forCamps: camps)
            }else{
                p.setTreeNodes(forCamps: nil)
            }
        }
        

    }
    


    
    //MARK: - NSComboBoxDataSource
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "locationComboBox":
                let locations = locationsArray().map({$0.name ?? "NOT SET"})
                if index < locations.count{
                    return locations[index]
                }
            case "campTypeComboBox":
                let types = campTypesArray().map({$0.name ?? "NOT SET"})
                if index < types.count{
                    return types[index]
                }
            default:
                print("What combo box is this \(identifier.rawValue) which I'm (CampsListViewController) a data source for? ")
            }
        }
        return nil
    }
    
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "locationComboBox":
                return locationsArray().count
            case "campTypeComboBox":
                return campTypesArray().count
            default:
                return 0
            }
        }
        return 0
    }
    
    private func selectedCamps() -> [Camp]{
        return campsAC?.selectedObjects as? [Camp] ?? []
    }
    
    private func locationsArray() -> [Location]{
        return campGroup?.locations?.allObjects as? [Location] ?? []
    }
    
    private func campTypesArray() -> [CampType]{
        return campGroup?.campTypes?.allObjects as? [CampType] ?? []
    }

    
}
