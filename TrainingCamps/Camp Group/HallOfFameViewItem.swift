//
//  HallOfFameViewItem.swift
//  TrainingCamps
//
//  Created by Steven Lord on 29/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class HallOfFameViewItem: NSCollectionViewItem {

    @objc dynamic var results: [HallOfFameResult]?{
        didSet{
            print("!!!! RESULTS SET !!!!")
        }
    }
    
    @IBOutlet var resultTitle: NSTextField!
    
    
}
