//
//  ParticipantFilterCombBox.swift
//  TrainingCamps
//
//  Created by Steven Lord on 27/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa
class ParticipantFilterComboBox: NSComboBox{
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addItems(withObjectValues: ParticipantFilter.AllFilters.map({$0.rawValue}).sorted(by: {$0 < $1}))
    }
    
}
