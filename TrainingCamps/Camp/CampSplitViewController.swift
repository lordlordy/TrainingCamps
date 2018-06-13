//
//  CampSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampSplitViewController: NSSplitViewController, CampViewControllerProtocol, CampGroupViewControllerProtocol{
    
    @objc dynamic var camp: Camp?
    @objc dynamic var campGroup: CampGroup?
    
    func setCamp(_ camp: Camp) {
        self.camp = camp
        for c in childViewControllers{
            if let cvcp = c as? CampViewControllerProtocol{
                cvcp.setCamp(camp)
            }
        }
        if let w = view.window{
            w.title = camp.campName ?? "Unkown Camp"
        }
    }
    
    func setCampGroup(_ campGroup: CampGroup) {
        self.campGroup = campGroup
        for child in childViewControllers{
            if let c = child as? CampGroupViewControllerProtocol{
                c.setCampGroup(campGroup)
            }
        }
    }
    
    
}
