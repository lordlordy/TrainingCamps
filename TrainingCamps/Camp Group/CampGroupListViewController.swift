//
//  CampGroupListViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 13/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampGroupListViewController: NSViewController, NSTableViewDelegate{
    
    @IBOutlet var campGroupArrayController: NSArrayController!
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {

        if let campGroup = selectedCampGroup(){
            if let p = parent as? CampGroupViewControllerProtocol{
                p.setCampGroup(campGroup)
            }
        }
        
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
