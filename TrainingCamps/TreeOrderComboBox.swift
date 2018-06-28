//
//  TreeOrderComboBox.swift
//  TrainingCamps
//
//  Created by Steven Lord on 25/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class TreeOrderComboBox : NSComboBox{
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addItems(withObjectValues: TreeGenerator.TreeOrder.All.map({$0.rawValue}).sorted(by: {$0 < $1}))
    }
    
}
