//
//  CampViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampViewController: NSViewController, CampViewControllerProtocol{
    
    @objc dynamic var camp: Camp?
    
    func setCamp(_ camp: Camp) {
        self.camp = camp
    }
    
}
