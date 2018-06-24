//
//  CampParticipant+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 14/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension CampParticipant: Rankable{

    
    
    @objc dynamic var trainingComplete: Bool{ return getDays().reduce(true, {$0 && $1.dayComplete})}
    @objc dynamic var racesComplete: Bool { return getRaces().filter({$0.race!.neededForCompletion}).reduce(true, {$0 && $1.raceComplete}) && getRaces().filter({$0.race!.neededForCompletion}).count == camp?.getRacesArray().filter({$0.neededForCompletion}).count ?? 0}
    @objc dynamic var campComplete: Bool{ return trainingComplete && racesComplete}
    
    @objc dynamic var campPoints: Int{ return Int(getRaces().reduce(0, {$0 + $1.campPoints}) + bonusPoints)}
    
    @objc dynamic var totalKM: Double           { return valueFor(.total, .KM)}
    @objc dynamic var totalSeconds: Double      { return valueFor(.total, .Seconds)}
    @objc dynamic var totalAscentMetres: Double { return valueFor(.total, .Ascent)}
    @objc dynamic var swimKM: Double            { return valueFor(.swim, .KM)}
    @objc dynamic var swimSeconds: Double       { return valueFor(.swim, .Seconds)}
    @objc dynamic var bikeKM: Double            { return valueFor(.bike, .KM)}
    @objc dynamic var bikeSeconds: Double       { return valueFor(.bike, .Seconds)}
    @objc dynamic var bikeAscentMetres: Double  { return valueFor(.bike, .Ascent)}
    @objc dynamic var runKM: Double             { return valueFor(.run, .KM)}
    @objc dynamic var runSeconds: Double        { return valueFor(.run, .Seconds)}
    @objc dynamic var runAscentMetres: Double   { return valueFor(.run, .Ascent)}
    @objc dynamic var bricks: Int               { return getDays().reduce(0, {$0 + ($1.brick ? 1:0)})}

    @objc dynamic var totalCompetitionSeconds: Double { return getPointsRaces().reduce(0.0, {$0 + $1.totalSeconds})}
    
    @objc dynamic var numberOfDays: Int { return days?.count ?? 0 }
    @objc dynamic var numberOfRaces: Int { return raceResults?.count ?? 0 }
    @objc dynamic var noTraining: Bool { return numberOfRaces == 0 && numberOfDays == 0}
    
    @objc dynamic var campParticipantNameString: String{
        get { return participant?.displayName ?? "NOT SET"}
        set{
            if let cg = camp?.campGroup{
                if let p: Participant = cg.participant(withDisplayName: newValue){
                    participant = p
                }
            }
        }
    }
    
    @objc dynamic var completionStatus: String{
        if campComplete{
            return "Camp Complete"
        }else if trainingComplete{
            return "Training Complete"
        }else if racesComplete{
            return "Races Complete"
        }else{
            return "-"
        }
    }
    
    @objc dynamic var completeStatusSortKey: Int{
        if campComplete{
            return 1
        }else if trainingComplete{
            return 2
        }else if racesComplete{
            return 3
        }else{
            return 4
        }
    }
    
    //MARK: - Rankable
    var gender: String { return participant?.gender ?? "Not Set" }
    var name: String { return participant?.uniqueName ?? "Not Set"}
    var campRole: String { return role ?? "Not Set"}
    var campName: String { return camp?.campName ?? "Not Set"}
    
    //MARK: - Rankable
    func rankFor(_ activity: String, _ unit: String) -> Rank{
        let filtered: [Rank] = rankingsArray().filter({$0.activity! == activity && $0.unit! == unit})
        if filtered.count > 0{
            return filtered[0]
        }
        let newRank: Rank = CoreDataStack.shared.newRank()
        newRank.activity = activity
        newRank.unit = unit
        mutableSetValue(forKey: RaceResultProperty.rankings.rawValue).add(newRank)
        return newRank
    }
    
    func performRank() {
        camp?.campGroup?.rank()
    }
    

    
    func generateTree() -> TreeNode{
        
        //TRAINING
        let trainingNode = ParticipantTrainingNode(name: "Training", date: camp!.campStart!)
        
        for d in getDays().sorted(by: {$0.day!.date! < $1.day!.date!}){
            let dayNode = ParticipantDayNode(day: d)
            trainingNode.addChild(dayNode)
        }
        
        //RACE RESULT
        let racesNode = ParticipantRacesNode(name: "Races", date: Date())
        
        for r in getRaces().sorted(by: {$0.race!.date! < $1.race!.date!}){
            let resultNode = ParticipantRaceResultNode(raceResult: r)
            racesNode.addChild(resultNode)
        }
        
        
        
        let participantCampNode = ParticipantCampNode(name: camp!.campName!, date: camp!.campStart!, training: trainingNode, races: racesNode)
        
        participantCampNode.rankChildren()
        racesNode.rankChildren()
        trainingNode.rankChildren()
        
        return participantCampNode

    }
    
    func getDays() -> [ParticipantDay]{
        return days?.allObjects as? [ParticipantDay] ?? []
    }
    
    func valueFor(_ a: Activity, _ u: Unit) -> Double{
        return valueFor(a.rawValue, u.rawValue)
    }
    
    func valueFor(_ activity: String, _ unit: String) -> Double{
        return getDays().reduce(0.0, {$0 + $1.valueFor(activity,unit)})
    }
    
    private func rankingsArray() -> [Rank]{
        return rankings?.allObjects as? [Rank] ?? []
    }
    
    private func getRaces() -> [RaceResult]{
        return raceResults?.allObjects as? [RaceResult] ?? []
    }
    
    private func getPointsRaces() -> [RaceResult]{
        return getRaces().filter({$0.includeInCampPoints})
    }
}
