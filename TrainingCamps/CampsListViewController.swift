//
//  CampsListViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampsListViewController: NSViewController, NSTableViewDelegate{
    
    @IBOutlet var campsArrayController: NSArrayController!
    @IBOutlet var campGroupArrayController: NSArrayController!
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let tv = notification.object as? NSTableView{
            if let tableName = tv.identifier?.rawValue{
                if tableName == "campListTable"{
                    if let camp = selectedCamp(){
                        if let p = parent as? CampViewControllerProtocol{
                            p.setCamp(camp)
                        }
                    }
                }else if tableName == "campGroupTable"{
                    if let campGroup = selectedCampGroup(){
                        if let p = parent as? CampGroupViewControllerProtocol{
                            p.setCampGroup(campGroup)
                        }
                    }
                }
            }
        }

    }
    
    private func selectedCamp() -> Camp?{
        if let cac = campsArrayController{
            if let camps = cac.selectedObjects as? [Camp]{
                if camps.count > 0{
                    return camps[0]
                }
            }
        }
        return nil
    }
    
    private func selectedCampGroup() -> CampGroup?{
        if let cgac = campGroupArrayController{
            if let campGroups = cgac.selectedObjects as? [CampGroup]{
                if campGroups.count > 0{
                    return campGroups[0]
                }
            }
        }
        return nil
    }
    
}
