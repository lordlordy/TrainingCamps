//
//  StickyHeaderFlowLayout.swift
//  TrainingCamps
//
//  Created by Steven Lord on 27/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class StickyHeaderFlowLayout: NSCollectionViewFlowLayout{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sectionHeadersPinToVisibleBounds = true
    }
}
