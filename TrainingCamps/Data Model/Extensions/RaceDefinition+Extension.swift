//
//  RaceDefinition+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 13/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension RaceDefinition{
    
    @objc dynamic var raceCount: Int{return races?.count ?? 0}
    @objc dynamic var resultsCount: Int { return allRaceResults.count }
    @objc dynamic var locationString: String {
        get{
            return location?.name ?? "Location not set"
        }
        set{
            if let cg = campGroup{
                if let l = cg.location(forName: newValue){
                    location = l
                }else{
                    print("Location \(newValue) not set up. Can't set this location for Race Definition: \(name ?? "")")
                }
            }
        }
    }
    
    @objc dynamic var typeString: String{
        var result: String = swimKM > 0.0 ? "Swim, " : ""
        result += bikeKM > 0.0 ? "Bike, " : ""
        result += runKM > 0.0 ? "Run, " : ""
        result = result.trimmingCharacters(in: CharacterSet.init(charactersIn: ", "))
        return result
    }
    
    @objc dynamic var disciplineCount: Int{
        return (swimKM > 0.0 ? 1:0) + (bikeKM > 0.0 ? 1:0) + (runKM > 0.0 ? 1:0)
    }

    @objc dynamic var allRaceResults: NSSet{
        var results: [RaceResult] = []
        if let allRaces = races?.allObjects as? [Race]{
            for r in allRaces{
                if let newResults = r.results?.allObjects as? [RaceResult]{
                    results.append(contentsOf: newResults)
                }
            }
        }
        return NSSet(array: results.filter({$0.campParticipant != nil})) 
    }
    
    @objc dynamic var meanSeconds: Double{ return stdDevMeanSum.mean}
    @objc dynamic var stdDevSeconds: Double { return stdDevMeanSum.stdDev}
    
    private var stdDevMeanSum: (stdDev: Double, mean: Double, total: Double){
        return Maths().stdDevMeanTotal(raceResultsArray().map({$0.totalSeconds}).filter({$0 > 0.0}))
    }
    
    private var stdDevMeanSumOfLogs: (stdDev: Double, mean: Double, total: Double){
        return Maths().stdDevMeanTotal(raceResultsArray().filter({$0.totalSeconds > 0.0}).map({log($0.totalSeconds)}))
    }
    
    func percentile(forResult r: RaceResult) -> Double{
        if r.race!.raceDefinition! == self{
            let stdDevsFromMean = (r.totalSeconds - stdDevMeanSum.mean) / stdDevMeanSum.stdDev
            let percentile = Maths().phi(stdDev: stdDevsFromMean)
            return percentile
        }else{
            return 0.0
        }
    }
    
    var firstRunning: Date?{
        let allRaces: [Race] = races?.allObjects as? [Race] ?? []
        let sorted: [Race] = allRaces.sorted(by: {$0.date! < $1.date!})
        if sorted.count > 0{
            return sorted[0].date
        }
        return nil
    }
    
    //exclude relays
    func overallTopTen() -> [HallOfFameResult]{
        let results = raceResultsArray().filter({!$0.isRelay}).sorted(by: {$0.rankBestOnly < $1.rankBestOnly})
        var array: [HallOfFameResult] = []
        var rank: Int32 = 1
        ranking: for r in results{
            array.append(HallOfFameResult.init(rank, r.campParticipant!.participant!.displayName, r.campParticipant!.camp!.campShortName!, value: r.totalSeconds, unit: Unit.Seconds))
            rank += 1
            if rank > 10{
                break ranking
            }
        }
        return array
    }
    
    func femaleTopTen() -> [HallOfFameResult]{
        let results = raceResultsArray().filter({!$0.isRelay && $0.gender == Gender.Female.rawValue}).sorted(by: {$0.rankGenderBestOnly < $1.rankGenderBestOnly})
        var array: [HallOfFameResult] = []
        var rank: Int32 = 1
        ranking: for r in results{
            array.append(HallOfFameResult.init(rank, r.campParticipant!.participant!.displayName, r.campParticipant!.camp!.campShortName!,value: r.totalSeconds, unit: Unit.Seconds))
            rank += 1
            if rank > 10{
                break ranking
            }
        }
        return array
    }
    
    func maleTopTen() -> [HallOfFameResult]{
        let results = raceResultsArray().filter({!$0.isRelay && $0.gender == Gender.Male.rawValue}).sorted(by: {$0.rankGenderBestOnly < $1.rankGenderBestOnly})
        var array: [HallOfFameResult] = []
        var rank: Int32 = 1
        ranking: for r in results{
            array.append(HallOfFameResult.init(rank, r.campParticipant!.participant!.displayName, r.campParticipant!.camp!.campShortName!, value: r.totalSeconds, unit: Unit.Seconds))
            rank += 1
            if rank > 10{
                break ranking
            }
        }
        return array
    }
    
    func raceResultsArray() -> [RaceResult]{
        return allRaceResults.allObjects as? [RaceResult] ?? []
    }
    
}
