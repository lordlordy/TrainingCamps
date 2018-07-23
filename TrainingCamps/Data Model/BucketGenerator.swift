//
//  BucketGenerator.swift
//  TrainingCamps
//
//  Created by Steven Lord on 19/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

protocol BucketGenerator{
    
    var nameGenerator: (Bucket) -> String {get set}
    
    func createBuckets(forDoubleProperty property: TrainingDataProtocolProperty, data: [TrainingDataProtocol]) -> [Bucket]
    
}

