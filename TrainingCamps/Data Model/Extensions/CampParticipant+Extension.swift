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
    
    @objc dynamic var overallRankTime: Int32{ return rankFor(Activity.total.rawValue, Unit.Seconds.rawValue).overall}
    @objc dynamic var overallRankTimeGender: Int32{ return rankFor(Activity.total.rawValue, Unit.Seconds.rawValue).gender}
    @objc dynamic var campRankTime: Int32{ return rankFor(Activity.total.rawValue, Unit.Seconds.rawValue).camp}

    @objc dynamic var overallRankSwimKM: Int32{ return rankFor(Activity.swim.rawValue, Unit.KM.rawValue).overall}
    @objc dynamic var overallRankSwimKMGender: Int32{ return rankFor(Activity.swim.rawValue, Unit.KM.rawValue).gender}
    @objc dynamic var campRankSwimKM: Int32{ return rankFor(Activity.swim.rawValue, Unit.KM.rawValue).camp}
    
    @objc dynamic var overallRankBikeKM: Int32{ return rankFor(Activity.bike.rawValue, Unit.KM.rawValue).overall}
    @objc dynamic var overallRankBikeKMGender: Int32{ return rankFor(Activity.bike.rawValue, Unit.KM.rawValue).gender}
    @objc dynamic var campRankBikeKM: Int32{ return rankFor(Activity.bike.rawValue, Unit.KM.rawValue).camp}
    
    @objc dynamic var overallRankRunKM: Int32{ return rankFor(Activity.run.rawValue, Unit.KM.rawValue).overall}
    @objc dynamic var overallRankRunKMGender: Int32{ return rankFor(Activity.run.rawValue, Unit.KM.rawValue).gender}
    @objc dynamic var campRankRunKM: Int32{ return rankFor(Activity.run.rawValue, Unit.KM.rawValue).camp}
    
    @objc dynamic var racesFinished: [RaceResult]{
        return getRaces().filter({$0.raceCompletionStatus! == RaceCompletionStatus.Y.rawValue})
    }
    
    @objc dynamic var durationPercentile: Double{
        return camp?.campGroup?.percentile(forActivity: Activity.total, andUnit: Unit.Seconds, isCamp: true, withValue: totalSeconds) ?? 0.0
    }
    
    @objc dynamic var swimKMPercentile: Double{
        return camp?.campGroup?.percentile(forActivity: Activity.swim, andUnit: Unit.KM, isCamp: true, withValue: swimKM) ?? 0.0
    }
    
    @objc dynamic var bikeKMPercentile: Double{
        return camp?.campGroup?.percentile(forActivity: Activity.bike, andUnit: Unit.KM, isCamp: true, withValue: bikeKM) ?? 0.0
    }
    
    @objc dynamic var runKMPercentile: Double{
        return camp?.campGroup?.percentile(forActivity: Activity.run, andUnit: Unit.KM, isCamp: true, withValue: runKM) ?? 0.0
    }
        
    //MARK: - Rankable
    var gender:     String { return participant?.gender ?? "Not Set" }
    var name:       String? { return participant?.displayName }
    var campRole:   String { return role ?? "Not Set"}
    var campName:   String { return camp?.campName ?? "Not Set"}
    
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
    
    
    func getDays() -> [ParticipantDay]{
        return days?.allObjects as? [ParticipantDay] ?? []
    }
    
    func valueFor(_ a: Activity, _ u: Unit) -> Double{
        return valueFor(a.rawValue, u.rawValue)
    }
    
    func valueFor(_ activity: String, _ unit: String) -> Double{
        switch unit{
        case Unit.KPH.rawValue:
            return getDays().reduce(0.0, {$0 + $1.valueFor(activity,Unit.KM.rawValue)}) / getDays().reduce(0.0, {$0 + $1.valueFor(activity,Unit.Hours.rawValue)})
        case Unit.MPH.rawValue:
            return getDays().reduce(0.0, {$0 + $1.valueFor(activity,Unit.Miles.rawValue)}) / getDays().reduce(0.0, {$0 + $1.valueFor(activity,Unit.Hours.rawValue)})
        default:
            return getDays().reduce(0.0, {$0 + $1.valueFor(activity,unit)})
        }

    }
    
    private func rankingsArray() -> [Rank]{
        return rankings?.allObjects as? [Rank] ?? []
    }
    
    func getRaces() -> [RaceResult]{
        return raceResults?.allObjects as? [RaceResult] ?? []
    }
    
    private func getPointsRaces() -> [RaceResult]{
        return getRaces().filter({$0.includeInCampPoints})
    }
}
