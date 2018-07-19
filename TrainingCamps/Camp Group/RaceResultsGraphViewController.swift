//
//  RaceResultsGraphViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 18/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

//struct Bucket{
//    
//    var name: String
//    var from: CGFloat
//    var to: CGFloat
//    var size: CGFloat
//    
//    func midPoint() -> CGFloat{
//        return (from + to) / 2.0
//    }
//    
//}

class RaceResultsGraphViewController: NSViewController, RaceDefinitionViewControllerProtocol{
    
    @IBOutlet weak var graphView: DistributionGraph!
    let numberOfBuckets: Int = 21 // odd number
    
    func setRaceDefinition(_ raceDefinition: RaceDefinition) {
        let nonZero: [RaceResult] = raceDefinition.raceResultsArray().filter({$0.totalSeconds > 0.0})
        let fastest: Double = nonZero.reduce(36000.0, {min($0, $1.totalSeconds)})-1.0
        let slowest: Double = nonZero.reduce(0.0, {max($0, $1.totalSeconds)})+1

        let bucketWidth = (slowest - fastest) / Double(numberOfBuckets)
        
        var buckets: [Bucket] = []
        var from: Double = fastest
        var to: Double = fastest + bucketWidth
        let timeFormatter: TransformerNSNumberToTimeFormat = TransformerNSNumberToTimeFormat()
        if slowest < 3600.0{ // an hour
            timeFormatter.includeHours = false
        }
        
        for _ in 1...numberOfBuckets{
            let size: Double = Double(nonZero.filter({$0.totalSeconds >= from && Double($0.totalSeconds) < to}).count)
            var name: String = timeFormatter.transformedValue(from) as! String
            name += " to "
            name += timeFormatter.transformedValue(to) as! String
            buckets.append(Bucket(name: name, from: from, to: to, size: size))
            from += bucketWidth
            to += bucketWidth
        }
        
        
        graphView.set(buckets: buckets, mean: raceDefinition.meanSeconds, variance: pow(raceDefinition.stdDevSeconds, 2.0))
        setBucketTable(withBuckets: buckets.filter({$0.size > 0.0}))
    }
    
    func setHighlightedValue(_ x: [Double]){
        graphView.setHighlighted(x: x)
    }
    
    private func setBucketTable(withBuckets buckets: [Bucket]){
        if let p = parent{
            for c in p.childViewControllers{
                if let b = c as? BucketsViewController{
                    b.buckets = buckets
                }
            }
        }
    }
    
}
