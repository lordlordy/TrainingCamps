//
//  CampsTabViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampsTabViewController: NSTabViewController, CampViewControllerProtocol, CampGroupViewControllerProtocol{
    
    func setCamp(_ camp: Camp) {
        for c in childViewControllers{
            if let cvcp = c as? CampViewControllerProtocol{
                cvcp.setCamp(camp)
            }
        }
    }
    
    func setCampGroup(_ campGroup: CampGroup) {
        for c in childViewControllers{
            if let cgvcp = c as? CampGroupViewControllerProtocol{
                cgvcp.setCampGroup(campGroup)
            }
        }
    }
    
}
