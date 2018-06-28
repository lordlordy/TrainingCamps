//
//  ParticipantEddingtonNumbersViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 28/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class ParticipantEddingtonNumbersViewController: NSViewController, ParticipantViewControllerProtocol{
    
    @objc dynamic var participant: Participant?
    
    @IBOutlet var eddingtonNumberArrayController: NSArrayController!
    
    @IBAction func createEntries(_ sender: Any) {
        if let enac = eddingtonNumberArrayController{
            let currentEntries: [EddingtonNumber] = enac.arrangedObjects as? [EddingtonNumber] ?? []
            for a in Activity.Eddington{
                for u in a.validEddingtonUnits(){
                    if currentEntries.filter({$0.activity == a.rawValue && $0.unit == u.rawValue}).count == 0{
                        // no entry
                        let newEd: EddingtonNumber = CoreDataStack.shared.newEddingtonNumber()
                        newEd.activity = a.rawValue
                        newEd.unit = u.rawValue
                        if let p = participant{
                            p.mutableSetValue(forKey: ParticipantProperty.eddingtonNumbers.rawValue).add(newEd)
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func calculate(_ sender: Any) {
        if let selection = eddingtonNumberArrayController.selectedObjects as? [EddingtonNumber]{
            for s in selection{
                s.calculate()
            }
        }
    }
    
    func setParticipant(_ participant: Participant) {
        self.participant = participant
    }
    
}
