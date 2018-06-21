//
//  RacesSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 06/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class RacesSplitViewController: CampSplitViewController{
    
    
//    @IBOutlet var racesAC: NSArrayController!
//    @IBOutlet var resultsAC: NSArrayController!
    
//    func selectedRaceChanged(){
//        if let race = selectedRace(){
//            setRace(race)
//        }
//    }
    
    func setRace(_ race: Race) {
        for i in getRaceViewControllerProtocols(){
            i.setRace(race)
        }
    }
    
//    private func selectedRace() -> Race?{
//        if let races = racesAC.selectedObjects as? [Race]{
//            if races.count > 0{
//                return races[0]
//            }
//        }
//        return nil
//    }

    
    private func getRaceViewControllerProtocols() -> [RaceViewControllerProtocol]{
        var result: [RaceViewControllerProtocol] = []
        for c in childViewControllers{
            if let r = c as? RaceViewControllerProtocol{
                result.append(r)
            }
        }
        return result
    }
}
