//
//  CampsListViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampsListViewController: CampGroupViewController, NSTableViewDelegate{
    
    @IBOutlet var campsAC: NSArrayController!
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let camp = selectedCamp(){
            if let p = parent as? CampViewControllerProtocol{
                p.setCamp(camp)
            }
        }

    }
    
    private func selectedCamp() -> Camp?{
        if let cac = campsAC{
            if let camps = cac.selectedObjects as? [Camp]{
                if camps.count > 0{
                    return camps[0]
                }
            }
        }
        return nil
    }
    

    
}
