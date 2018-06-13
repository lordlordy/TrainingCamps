//
//  CampGroupTabViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 13/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampGroupTabViewController: NSTabViewController, CampGroupViewControllerProtocol{
    
    
    func setCampGroup(_ campGroup: CampGroup) {
        for child in childViewControllers{
            if let c = child as? CampGroupViewControllerProtocol{
                c.setCampGroup(campGroup)
            }
        }
    }
    
}
