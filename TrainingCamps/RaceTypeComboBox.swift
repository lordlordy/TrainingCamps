//
//  RaceTypeComboBox.swift
//  TrainingCamps
//
//  Created by Steven Lord on 22/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa
class RaceTypeComboBox: NSComboBox{
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addItems(withObjectValues: RaceType.All.map({$0.rawValue}).sorted(by: {$0 < $1}))
    }
    
    
}
