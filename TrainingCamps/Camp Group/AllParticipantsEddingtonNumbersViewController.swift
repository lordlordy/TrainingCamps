//
//  AllParticipantsEddingtonNumbersViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 28/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class AllParticipantsEddingtonNumbersViewController: CampGroupViewController, NSComboBoxDataSource{
    
    
    @IBOutlet var eddingtonNumbersAC: NSArrayController!
    
    @objc dynamic var participantDisplayName: String?{
        didSet{
            setFilterPredicate()
        }
    }
    
    @objc dynamic var filter: String?{
        didSet{
            setFilterPredicate()
        }
    }
    
    @IBAction func calculateSelection(_ sender: Any?){
        for s in eddingtonNumbersAC.selectedObjects as? [EddingtonNumber] ?? []{
            s.calculate()
        }
    }
    
    @IBAction func rank(_ sender: Any?){
        campGroup?.rankParticipantEddingtonNumbers()
    }
    
    //MARK: - NSComboBoxDataSource   participantsOnCampComboBox
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        if let participants = campGroup?.participantArray().map({$0.displayName}){
            if participants.count > index{
                return participants[index]
            }
        }
        return nil
    }
    
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return campGroup?.participantArray().count ?? 0
    }
    
    private func setFilterPredicate(){
        var argArray: [Any] = []
        var predicateString: String = ""
        
        if let p = participantDisplayName{
            predicateString = "name contains %@"
            argArray.append(p)
        }
        if let f = filter{
            if predicateString != ""{
                predicateString += " AND "
            }
            predicateString += "code contains %@"
            argArray.append(f)
        }
        if predicateString == ""{
            eddingtonNumbersAC.filterPredicate = nil
        }else{
            eddingtonNumbersAC.filterPredicate = NSPredicate(format: predicateString, argumentArray: argArray)
        }
        
    }
    
}
