//
//  PointsMethodComboBox.swift
//  TrainingCamps
//
//  Created by Steven Lord on 20/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa
class PointsMethodComboBox: NSComboBox{
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addItems(withObjectValues: PointsMethod.All.map({$0.rawValue}))
    }

    
}
