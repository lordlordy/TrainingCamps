//
//  ParticipantDay+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 13/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension ParticipantDay: Rankable{

    var name: String? { return campParticipant?.participant?.displayName }
    
    var gender: String      { return campParticipant?.participant?.gender ?? "Not set" }
    var campRole: String    { return campParticipant?.role ?? "Not set"}
    var campName: String    { return campParticipant?.camp?.campName ?? "Not Set"}
    
    @objc dynamic var totalSeconds: Double{ return swimSeconds + bikeSeconds + runSeconds }
    @objc dynamic var totalKM: Double{ return swimKM + bikeKM + runKM }
    @objc dynamic var totalAscentMetres: Double{return bikeAscentMetres + runAscentMetres}
    
    @objc dynamic var totalKPH: Double { return (totalSeconds > 0.0) ? (totalKM / (totalSeconds / 3600.0)) : 0.0}
    @objc dynamic var bikeKPH: Double { return (bikeSeconds > 0.0) ? (bikeKM / (bikeSeconds / 3600.0)) : 0.0}
    @objc dynamic var runKPH: Double { return (runSeconds > 0.0) ? (runKM / (runSeconds / 3600.0)) : 0.0}
    
    @objc dynamic var swimComplete: Bool{ return day?.swimComplete(particpantDay: self) ?? false }
    @objc dynamic var bikeComplete: Bool{ return day?.bikeComplete(particpantDay: self) ?? false }
    @objc dynamic var runComplete: Bool{ return day?.runComplete(particpantDay: self) ?? false }
    @objc dynamic var dayComplete: Bool{ return swimComplete && bikeComplete && runComplete }
    
    @objc dynamic var trainingCompletionStatus: String{
        if dayComplete{
            return "Day Completed"
        }else{
            var str: String = swimComplete ? "Swim, ":""
            str += bikeComplete ? "Bike, ":""
            str += runComplete ? "Run, ":""
            str = str.trimmingCharacters(in: CharacterSet.init(charactersIn: ", "))
            return str
        }
    }

    @objc dynamic var swimWildcardEarned: Bool { return day?.swimWildCardEarned(forParticipantDay: self) ?? false}
    @objc dynamic var bikeWildcardEarned: Bool { return day?.bikeWildCardEarned(forParticipantDay: self) ?? false}
    @objc dynamic var runWildcardEarned: Bool { return day?.runWildCardEarned(forParticipantDay: self) ?? false}
    
    @objc dynamic var wildcardsEarned: String{
        var str: String = swimWildcardEarned ? "Swim, ":""
        str += bikeWildcardEarned ? "Bike, ":""
        str += runWildcardEarned ? "Run, ":""
        str = str.trimmingCharacters(in: CharacterSet.init(charactersIn: ", "))
        return str
    }

    
    @objc dynamic var zeroTraining: Bool{ return totalSeconds == 0 }
    
    @objc dynamic var dateString: String{
        get{
            let df: DateFormatter = DateFormatter()
            df.dateFormat = DateFormatString.ValidCampDate.rawValue
            if let d = day?.date{
                return df.string(from: d)
            }else{
                return "NOT SET"
            }
        }
        set{
            let df: DateFormatter = DateFormatter()
            df.dateFormat =  DateFormatString.ValidCampDate.rawValue
            if let d: Date = df.date(from: newValue){
                if let camp: Camp = campParticipant?.camp{
                    day = camp.campDay(forDate: d)
                }
            }
        }
    }
    
    @objc dynamic var displayName: String{
        get{
            return campParticipant?.participant?.displayName ?? "NOT SET"
        }
        set{
            if let c = campParticipant?.camp{
                campParticipant = c.campParticipant(forDisplayName: newValue)
            }
        }
    }
    
    override public class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String>{
        let keyPaths = super.keyPathsForValuesAffectingValue(forKey: key)
        switch key {
        case ParticipantDayProperty.totalSeconds.rawValue:
            return keyPaths.union(Set([ParticipantDayProperty.swimSeconds.rawValue, ParticipantDayProperty.bikeSeconds.rawValue, ParticipantDayProperty.runSeconds.rawValue]))
        case ParticipantDayProperty.totalKM.rawValue:
            return keyPaths.union(Set([ParticipantDayProperty.swimKM.rawValue, ParticipantDayProperty.bikeKM.rawValue, ParticipantDayProperty.runKM.rawValue]))
        case ParticipantDayProperty.totalAscentMetres.rawValue:
                return keyPaths.union(Set([ParticipantDayProperty.bikeAscentMetres.rawValue, ParticipantDayProperty.runAscentMetres.rawValue]))
        case ParticipantDayProperty.swimComplete.rawValue:
            return keyPaths.union(Set([ParticipantDayProperty.swimSeconds.rawValue]))
        case ParticipantDayProperty.bikeComplete.rawValue:
            return keyPaths.union(Set([ParticipantDayProperty.bikeKM.rawValue]))
        case ParticipantDayProperty.runComplete.rawValue:
            return keyPaths.union(Set([ParticipantDayProperty.runSeconds.rawValue]))
        case ParticipantDayProperty.dayComplete.rawValue, ParticipantDayProperty.trainingCompletionStatus.rawValue:
            return keyPaths.union(Set([ParticipantDayProperty.swimComplete.rawValue, ParticipantDayProperty.bikeComplete.rawValue, ParticipantDayProperty.runComplete.rawValue, ParticipantDayProperty.runWildcardUsed.rawValue, ParticipantDayProperty.swimWildcardUsed.rawValue, ParticipantDayProperty.bikeWildcardUsed.rawValue]))
        default:
            return keyPaths
        }
    }
    
    //MARK: - Rankable
    func rankFor(_ activity: Activity, _ unit: Unit) -> Rank{
        switch unit{
        case .Ascent, .AscentFeet, .AscentMetres:
            return rankFor(activity.rawValue, Unit.Ascent.rawValue)
        case .Hours, .Minutes, .Seconds:
            return rankFor(activity.rawValue, Unit.Seconds.rawValue)
        case .KM, .Miles:
            return rankFor(activity.rawValue, Unit.KM.rawValue)
        case .KPH, .MPH:
            return rankFor(activity.rawValue, Unit.KPH.rawValue)
        }
    }
    
    func performRank() {
        campParticipant?.camp?.campGroup?.rank()
    }
    
    internal func rankFor(_ activity: String,_ unit: String) -> Rank{
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
    
    func valueFor(_ activity: String, _ unit: String) -> Double{
        if let a = Activity(rawValue: activity){
            if let u = Unit(rawValue: unit){
                return valueFor(a, u)
            }
        }
        return 0.0
    }
    

    
    func valueFor(_ activity: Activity,_ unit: Unit) -> Double{
        switch unit{
        case .Seconds, .Minutes, .Hours:
            switch activity{
            case .total: return totalSeconds * unit.factor()
            case .swim: return swimSeconds * unit.factor()
            case .t1: return 0.0
            case .bike: return bikeSeconds * unit.factor()
            case .t2: return 0.0
            case .run: return runSeconds * unit.factor()
            case .guessDifference: return 0.0
            case .handicapAdjusted: return 0.0
            }
        case .Ascent, .AscentMetres, .AscentFeet:
            switch activity{
            case .total: return totalAscentMetres * unit.factor()
            case .swim: return 0.0
            case .t1: return 0.0
            case .bike: return bikeAscentMetres * unit.factor()
            case .t2: return 0.0
            case .run: return runAscentMetres * unit.factor()
            case .guessDifference: return 0.0
            case .handicapAdjusted: return 0.0
            }
        case .KM, .Miles:
            switch activity{
            case .total: return totalKM * unit.factor()
            case .swim: return swimKM * unit.factor()
            case .t1: return 0.0
            case .bike: return bikeKM * unit.factor()
            case .t2: return 0.0
            case .run: return runKM * unit.factor()
            case .guessDifference: return 0.0
            case .handicapAdjusted: return 0.0
            }
        case .KPH, .MPH:
            switch activity{
            case .total: return totalKPH * unit.factor()
            case .swim: return 0.0
            case .t1: return 0.0
            case .bike: return bikeKPH * unit.factor()
            case .t2: return 0.0
            case .run: return runKPH * unit.factor()
            case .guessDifference: return 0.0
            case .handicapAdjusted: return 0.0
            }
            
        }
    }
    
    private func rankingsArray() -> [Rank]{
        return rankings?.allObjects as? [Rank] ?? []
    }
}
