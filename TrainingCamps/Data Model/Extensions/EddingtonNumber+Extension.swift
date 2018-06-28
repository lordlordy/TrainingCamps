//
//  EddingtonNumber+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 28/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension EddingtonNumber{
    
    @objc dynamic var name: String{
        if campGroup != nil{
            return "Camp"
        }else if let p = participant{
            return p.displayName
        }
        return "NOT SET"
    }
    
    @objc dynamic var code: String{
        var str: String = activity ?? "Not Set"
        str += ":"
        str += unit ?? "Not Set"
        return str
    }
    
    func calculate(){
        if let cg = campGroup{
            calcOverall(cg.participantDaysArray())
        }else if let p = participant{
            calcParticipant(p.participantDaysArray())
        }
    }
    
    override public class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String>{
        let keyPaths = super.keyPathsForValuesAffectingValue(forKey: key)
        switch key {
        case EddingtonNumberProperty.code.rawValue:
            return keyPaths.union(Set([EddingtonNumberProperty.activity.rawValue,EddingtonNumberProperty.unit.rawValue]))
        default:
            return keyPaths
        }
    }
    
    private func calcOverall(_ participantDays: [ParticipantDay]){
        if let activity = Activity(rawValue: activity ?? ""){
            if let unit = Unit(rawValue: unit ?? ""){
                let rankedValues: [(rank: Int32, value: Int32)] = participantDays.map({(rank: $0.rankFor(activity, unit).overall, value: Int32($0.valueFor(activity, unit)))}).sorted(by: {$0.rank < $1.rank})
                
                var edNum: Int32 = 0
                
                findEddington: for r in rankedValues{
                    if r.rank == r.value{
                        edNum = r.rank
                        break findEddington
                    }
                    if r.rank > r.value{
                        edNum = r.rank - 1
                        break findEddington
                    }
                }
                
                value = edNum
                plusOne = (edNum + 1 ) - Int32(rankedValues.filter({$0.value > edNum}).count)
                
            
            }
        }
    }

    private func calcParticipant(_ participantDays: [ParticipantDay]){
        if let activity = Activity(rawValue: activity ?? ""){
            if let unit = Unit(rawValue: unit ?? ""){
                let rankedValues: [(rank: Int32, value: Int32)] = participantDays.map({(rank: $0.rankFor(activity, unit).participant, value: Int32($0.valueFor(activity, unit)))}).sorted(by: {$0.rank < $1.rank})
                
                var edNum: Int32 = 0
                var found: Bool = false
                
                findEddington: for r in rankedValues{
                    if r.rank == r.value{
                        edNum = r.rank
                        found = true
                        break findEddington
                    }
                    if r.rank > r.value{
                        edNum = r.rank - 1
                        found = true
                        break findEddington
                    }
                }

                if !found { edNum = Int32(rankedValues.count)}
                
                value = edNum
                plusOne = (edNum + 1 ) - Int32(rankedValues.filter({$0.value > edNum}).count)
                
                
            }
        }
    }
}
