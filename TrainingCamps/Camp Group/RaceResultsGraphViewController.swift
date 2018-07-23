//
//  RaceResultsGraphViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 18/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa


class RaceResultsGraphViewController: NSViewController, RaceDefinitionViewControllerProtocol, NormalDistributionViewControllerProtocol{

    
    
    @IBOutlet weak var graphView: DistributionGraph!
    let numberOfBuckets: Int = 21 // odd number
    
    private var completerFilters: [DistributionSelection]?
    private var genderFilters: [DistributionSelection]?
    private var roleFilters: [DistributionSelection]?
    private var campTypeFilters: [DistributionSelection]?
    private var raceDefinition: RaceDefinition?
    
    func setRaceDefinition(_ raceDefinition: RaceDefinition) {
        self.raceDefinition = raceDefinition
        updateGraph()
    }
    
    func setHighlightedValue(_ x: [Double]){
        graphView.setHighlighted(x: x)
    }
    
    func updateBuckets(forSelection selection: [DistributionSelection]) {
        print("Updating buckets again")
        let completer: [DistributionSelection] = selection.filter({$0.isCompletion})
        let gender: [DistributionSelection] = selection.filter({$0.isGender})
        let role: [DistributionSelection] = selection.filter({$0.isRole})
        let campType: [DistributionSelection] = selection.filter({$0.isCampType})
        
        if completer.reduce(true, {$0 && $1.include}){
            // all true so set fitlers to nil
            completerFilters = nil
        }else{
            completerFilters = completer
        }
        
        if gender.reduce(true, {$0 && $1.include}){
            genderFilters = nil
        }else{
            genderFilters = gender
        }
        
        if role.reduce(true, {$0 && $1.include}){
            roleFilters = nil
        }else{
            roleFilters = role
        }
        
        if campType.reduce(true, {$0 && $1.include}){
            campTypeFilters = nil
        }else{
            campTypeFilters = campType
        }
        updateGraph()
    }
    
    private func updateGraph(){
        guard (raceDefinition != nil) else { return }
        let nonZero: [RaceResult] = filter(data:raceDefinition!.raceResultsArray().filter({$0.totalSeconds > 0.0}))
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
        
        let meanStdDev = Maths().stdDevMeanTotal(nonZero.map({$0.totalSeconds}))
        
        graphView.set(buckets: buckets, mean: meanStdDev.mean, variance: pow(meanStdDev.stdDev, 2.0))
        setBucketTable(withBuckets: buckets.filter({$0.size > 0.0}))
    }
    
    private func filter(data: [RaceResult]) -> [RaceResult]{
        var result: [RaceResult] = data
        if completerFilters != nil{
            //filter on completers
            result = result.filter(filterCompleters)
        }
        if genderFilters != nil{
            result = result.filter(filterGenders)
        }
        if roleFilters != nil{
            result = result.filter(filterRoles)
        }
        if campTypeFilters != nil{
            result = result.filter(filterCampTypes)
        }

        return result
    }
    
    private func filterCompleters(tdp: RaceResult) -> Bool{
        for i in completerFilters ?? []{
            if i.name == DistributionSelectionTypes.Completers.rawValue{
                if i.include{
                    //include completers
                    return tdp.campParticipant!.campComplete
                }
            }else if i.name == DistributionSelectionTypes.NonCompleters.rawValue{
                if i.include{
                    //include  Non Completers
                    return !tdp.campParticipant!.campComplete
                }
            }
        }
        return false
    }
    
    private func filterGenders(tdp: RaceResult) -> Bool{
        var result = false
        for i in genderFilters ?? []{
            if tdp.campParticipant!.participant!.gender! == i.name{
                result = result || i.include
            }
        }
        return result
    }
    
    private func filterRoles(tdp: RaceResult) -> Bool{
        var result = false
        for i in roleFilters ?? []{
            if tdp.campParticipant!.role! == i.name{
                result = result || i.include
            }
        }
        return result
    }
    
    private func filterCampTypes(tdp: RaceResult) -> Bool{
        var result = false
        for i in campTypeFilters ?? []{
            if tdp.campParticipant!.camp!.campType == i.name{
                result = result || i.include
            }
        }
        return result
    }
    
    private func setBucketTable(withBuckets buckets: [Bucket]){
        if let p = parent{
            if let b = findBucketView(fromVCs: p.childViewControllers){
                b.buckets = buckets
            }
        }
    }
    
    private func findBucketView(fromVCs vcs: [NSViewController]) -> BucketsViewController?{
        for child in vcs{
            if let vc = child as? BucketsViewController{
                return vc
            }
        }
        for child in vcs{
            if let bvc = findBucketView(fromVCs: child.childViewControllers){
                return bvc
            }
        }
        return nil
    }
    
}
