//
//  FixedNumberOfBucketsBucketGenerator.swift
//  TrainingCamps
//
//  Created by Steven Lord on 20/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class FixedNumberOfBucketsBucketGenerator: BucketGenerator{
    
    var numberOfBuckets: Int = 21 // odd number
    var nameGenerator: (Bucket) -> String = {
        var result: String = String(Int($0.from))
        result += " to "
        result += String(Int($0.to))
        return result
    }
    
    func createBuckets(forDoubleProperty property: TrainingDataProtocolProperty, data: [TrainingDataProtocol]) -> [Bucket] {
        var buckets: [Bucket] = []
        
        if let doublesData = data.map({$0.value(forKey: property.rawValue)}) as? [Double]{
            
            
            let maxValue: Double = doublesData.reduce(0.0, {max($0, $1)})+1
            let minValue: Double = doublesData.reduce(maxValue, {min($0, $1)})-1.0
            
            let bucketWidth = (maxValue - minValue) / Double(numberOfBuckets)
            
            var from: Double = minValue
            var to: Double = minValue + bucketWidth
            
            for _ in 1...numberOfBuckets{
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
