//
//  GenderComboBox.swift
//  TrainingCamps
//
//  Created by Steven Lord on 18/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class GenderComboBox: NSComboBox{
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addItems(withObjectValues: [Gender.Female.rawValue, Gender.Male.rawValue])
    }

    
}
