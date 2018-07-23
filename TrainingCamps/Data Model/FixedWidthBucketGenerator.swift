//
//  FixedWidthBucketGenerator.swift
//  TrainingCamps
//
//  Created by Steven Lord on 20/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class FixedWidthBucketGenerator: BucketGenerator{
    
    var start: Double
    var bucketWidth: Double
    
    var nameGenerator: (Bucket) -> String = {
        var result: String = String(Int($0.from))
        result += " to "
        result += String(Int($0.to))
        return result
    }

    init(startingAt: Double, width: Double){
        start = startingAt
        bucketWidth = width
    }

    
    func createBuckets(forDoubleProperty property: TrainingDataProtocolProperty, data: [TrainingDataProtocol]) -> [Bucket] {
        var buckets: [Bucket] = []
        
        if let doublesData = data.map({$0.value(forKey: property.rawValue)}) as? [Double]{
            
            let maxValue: Double = doublesData.reduce(0.0, {max($0, $1)})+1
            
            //            let bucketWidth = (maxValue - minValue) / Double(numberOfBuckets)
            
            var from: Double = start
            var to: Double = start + bucketWidth
            
            while to < maxValue{
                let size: Double = Double(doublesData.filter({$0 >= from && $0 < to}).count)
                let bucket: Bucket = Bucket(name: "", from: from, to: to, size: size)
                bucket.name = nameGenerator(bucket)
                buckets.append(bucket)
                from += bucketWidth
                to += bucketWidth
            }
        }
        return buckets
    }
    
}
