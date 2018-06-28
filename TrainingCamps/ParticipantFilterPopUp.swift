//
//  ParticipantFilterPopUp.swift
//  TrainingCamps
//
//  Created by Steven Lord on 27/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class ParticipantFilterPopUp: NSPopUpButton{
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.removeAllItems()
        
        self.addItems(withTitles: ["one", "two", "three", "four"])
     
        self.title = "THis is the title"
        for i in self.itemArray{
            i.state = .on
        }
    }
    
    
}
