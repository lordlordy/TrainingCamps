//
//  Rank+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 22/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension Rank{
    
    @objc dynamic var rankName: String{ return (activity ?? "Activity not set") + (unit ?? "Unit not set")}
    
    @objc dynamic var hasRankings: Bool {
        return overall + gender + participant + camp + role < Constants.lastPlaceRank
    }
    
    @objc dynamic var activityShortName: String{
        if let a = activity{
            switch a{
            case Activity.guessDifference.rawValue: return "guess"
            case Activity.handicapAdjusted.rawValue: return "handicap"
            default: return a
            }
        }
        return "NOT SET"
    }
    
    @objc dynamic var name: String{
        var result: String = (activity ?? "not set") + " "
        let u = unit ?? "not set"
        if u == Unit.Seconds.rawValue{
            result += "Time"
        }else{
            result += u
        }
        return result
    }
    
    @objc dynamic var value: Double{
        if let pDay = participantDay{
            return pDay.valueFor(activity!, unit!)
        }else if let pCamp = campParticipant{
            return pCamp.valueFor(activity!, unit!)
        }else{
            return 0.0
        }
    }
    
}
