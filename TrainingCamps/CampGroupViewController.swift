//
//  CampGroupViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 06/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampGroupViewController: NSViewController, CampGroupViewControllerProtocol{
    
    @objc dynamic var campGroup: CampGroup?
    
    func setCampGroup(_ campGroup: CampGroup) {
        self.campGroup = campGroup
    }
    
}
