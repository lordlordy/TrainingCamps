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
    
    var firstRunning: Date?{
        let allRaces: [Race] = races?.allObjects as? [Race] ?? []
        let sorted: [Race] = allRaces.sorted(by: {$0.date! < $1.date!})
        if sorted.count > 0{
            return sorted[0].date
        }
        return nil
    }
    
}
