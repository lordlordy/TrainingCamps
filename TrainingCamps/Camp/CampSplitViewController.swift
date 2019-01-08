//
//  CampSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampSplitViewController: NSSplitViewController, CampViewControllerProtocol, CampGroupViewControllerProtocol, TreeGeneratorViewControllerProtocol{
    
    func setGenerator(_ treeNodeGenerator: TreeNodeGenerator) {
        for c in children{
            if let tree = c as? TreeGeneratorViewControllerProtocol{
                tree.setGenerator(treeNodeGenerator)
            }
        }
    }
    
    
    func setCamp(_ camp: Camp) {
        for c in children{
            if let cvcp = c as? CampViewControllerProtocol{
                cvcp.setCamp(camp)
            }
        }
        if let w = view.window{
            w.title = camp.campName ?? "Unkown Camp"
        }
    }
    
    func setCampGroup(_ campGroup: CampGroup) {
        for child in children{
            if let c = child as? CampGroupViewControllerProtocol{
                c.setCampGroup(campGroup)
            }
        }
    }
    
    
}
