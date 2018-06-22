//
//  RaceCompletionStatusComboBox.swift
//  TrainingCamps
//
//  Created by Steven Lord on 20/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa
class RaceCompletionStatusComboBox: NSComboBox{
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addItems(withObjectValues: RaceCompletionStatus.All.map({$0.rawValue}).sorted(by: {$0 < $1}))
    }
    
}
