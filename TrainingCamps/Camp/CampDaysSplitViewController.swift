//
//  CampDaysSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampDaysSplitViewController: CampSplitViewController, DayViewControllerProtocol{
    

    func setDay(_ day: Day) {
        for c in childViewControllers{
            if let dvcp = c as? DayViewControllerProtocol{
                dvcp.setDay(day)
            }
        }
    }
    
}
