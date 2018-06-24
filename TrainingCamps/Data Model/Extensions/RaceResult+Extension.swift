//
//  RaceResult+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 14/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension RaceResult{

    @objc dynamic var uniqueName: String{
        return campParticipant?.participant?.uniqueName ?? "PARTICIPANT NOT SET"
    }
    
    @objc dynamic var raceComplete: Bool{
        if let status = raceCompletionStatus{
            return status == RaceCompletionStatus.Y.rawValue || status == RaceCompletionStatus.Ydnf.rawValue
        }
        return false
    }
    
    @objc dynamic var raceNeededForCompletion: String{
        if race?.neededForCompletion ?? false{
            return "Needed For Completion"
        }
        return ""
    }
    
    @objc dynamic var completionStatus: String{ return raceComplete ? "Race Complete":""}
    @objc dynamic var totalSeconds: Double{ return swimSeconds + bikeSeconds + runSeconds}
    @objc dynamic var guessDifferenceSeconds: Double { return abs(totalSeconds - guessSeconds)}
    
    @objc dynamic var handicapAdjustedSeconds: Double { return totalSeconds == 0.0 ? 0.0 : totalSeconds + handicapSeconds}

    @objc dynamic var displayName: String{
        get{
            return campParticipant?.participant?.displayName ?? "Name Not Set"
        }
        set{
            if let c = race?.camp{
                if let p = c.campParticipant(forDisplayName: newValue){
                    campParticipant = p
                }
            }
        }
    }
    
    @objc dynamic var totalRank: Rank { return rankFor(activity: .total, unit: .Seconds)}
    @objc dynamic var swimRank: Rank { return rankFor(activity: .swim, unit: .Seconds)}
    @objc dynamic var bikeRank: Rank { return rankFor(activity: .bike, unit: .Seconds)}
    @objc dynamic var runRank: Rank { return rankFor(activity: .run, unit: .Seconds)}
    @objc dynamic var t1Rank: Rank { return rankFor(activity: .t1, unit: .Seconds)}
    @objc dynamic var t2Rank: Rank { return rankFor(activity: .t2, unit: .Seconds)}
    @objc dynamic var guessRank: Rank { return rankFor(activity: .guessDifference, unit: .Seconds)}
    @objc dynamic var handicapRank: Rank { return rankFor(activity: .handicapAdjusted, unit: .Seconds)}
    
    @objc dynamic var rank: Int32 { return totalRank.camp}
    @objc dynamic var rankGender: Int32 { return totalRank.campGender}
    @objc dynamic var rankAfterHandicap: Int32 { return handicapRank.camp}
    @objc dynamic var rankOverall: Int32 { return totalRank.overall}
    @objc dynamic var rankGenderOverall: Int32 { return totalRank.gender}
    @objc dynamic var rankParticipant: Int32 { return totalRank.participant}
    @objc dynamic var rankRole: Int32 { return totalRank.role}


//    func valueFor(activity: Activity, unit: Unit, gender: Gender, role: Role, location: Location?, participant: Participant?, camp: Camp?) ->  Double {
//
//        if participantIs(gender: gender, role: role, participant: participant){
//            if camp == nil || camp == race!.camp!{
//                if location == nil || location == race!.camp!.location!{
//                    return valueFor(activity: activity, unit: unit)
//                }
//            }
//        }
//        return 0.0
//    }
    
    // creates rank if not available
    func rankFor(activity: Activity, unit: Unit) -> Rank{
        return rankFor(activity: activity.rawValue, unit: unit.rawValue)
    }

    func rankFor(activity: String, unit: String) -> Rank{
        let filtered: [Rank] = rankingsArray().filter({$0.activity! == activity && $0.unit! == unit})
        if filtered.count > 0{
            return filtered[0]
        }
        let newRank: Rank = CoreDataStack.shared.newRank()
        newRank.activity = activity
        newRank.unit = unit
        newRank.camp = Constants.lastPlaceRank
        newRank.campGender = Constants.lastPlaceRank
        newRank.gender = Constants.lastPlaceRank
        newRank.overall = Constants.lastPlaceRank
        newRank.participant = Constants.lastPlaceRank
        mutableSetValue(forKey: RaceResultProperty.rankings.rawValue).add(newRank)
        return newRank
    }
    
    private func rankingsArray() -> [Rank]{
        return rankings?.allObjects as? [Rank] ?? []
    }
    
    private func participantIs(gender: Gender, role: Role, participant: Participant?) -> Bool{
        let isParticipant: Bool = (participant == nil) || (participant == self.campParticipant!.participant!)
        let isGender: Bool = (gender == Gender.All) || (campParticipant!.participant!.gender! == gender.rawValue)
        let isRole: Bool = (role == Role.All) || (campParticipant!.role! == role.rawValue)
        
        return isParticipant && isGender && isRole
    }
    
    private func valueFor(activity: Activity, unit: Unit) -> Double{
        switch unit{
        case .Seconds:
            switch activity{
            case .total: return totalSeconds
            case .swim: return swimSeconds
            case .t1: return t1Seconds
            case .bike: return bikeSeconds
            case .t2: return t2Seconds
            case .run: return runSeconds
            case .guessDifference: return guessDifferenceSeconds
            case .handicapAdjusted: return handicapAdjustedSeconds
            }
        default:
            return 0.0

        }
    }
    
}
