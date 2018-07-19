//
//  Bucket.swift
//  TrainingCamps
//
//  Created by Steven Lord on 19/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class Bucket: NSObject{
  
    @objc dynamic var name: String = ""
    @objc dynamic var from: Double = 0.0
    @objc dynamic var to: Double = 0.0
    @objc dynamic var size: Double = 0.0
    
    init(name: String, from: Double, to: Double, size: Double){
        self.name = name
        self.from = from
        self.to = to
        self.size = size
    }
    
    func midPoint() -> Double{
        return (from + to) / 2.0
    }
    
}
