//
//  Ranker.swift
//  TrainingCamps
//
//  Created by Steven Lord on 23/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class Ranker{
    
    func rank(_ items: [Rankable], forRankUnits rankUnits: [(activity: Activity, unit: Unit)], isAscending: Bool){
    
        if isAscending{
            
        }else{
            for u in rankUnits{
                let sortedItems: [Rankable] = items.sorted(by: {$0.valueFor( u.activity.rawValue, u.unit.rawValue) > $1.valueFor( u.activity.rawValue,  u.unit.rawValue)})
                var rank: Int32 = 1
                var bestOnlyRank: Int32 = 1
                
                var bestOnly: Set<String> = Set<String>()
                
                
                
                //overall rank
                for d in sortedItems{
                    let rankItem: Rank = d.rankFor( u.activity.rawValue, u.unit.rawValue)
                    rankItem.overall = rank
                    if bestOnly.contains(d.name!){
                        rankItem.bestOnly = Constants.lastPlaceRank
                    }else{
                        rankItem.bestOnly = bestOnlyRank
                        bestOnlyRank += 1
                        bestOnly.insert(d.name!)
                    }
                    rank += 1
                }
                
                //gender rank
                let genderSort = items.sorted(by: {($0.gender, $0.valueFor( u.activity.rawValue, u.unit.rawValue)) > ($1.gender, $1.valueFor( u.activity.rawValue,  u.unit.rawValue))})
                
                var currentGender = ""
                bestOnlyRank = 1
                bestOnly = Set<String>()
                for r in genderSort{
                    if r.gender != currentGender{
                        rank = 1
                        bestOnlyRank = 1
                        currentGender = r.gender
                        bestOnly = Set<String>()
                    }
                    let rankItem: Rank = r.rankFor( u.activity.rawValue,  u.unit.rawValue)
                    rankItem.gender = rank
                    rank += 1
                    if bestOnly.contains(r.name!){
                        rankItem.bestOnlyGender = Constants.lastPlaceRank
                    }else{
                        rankItem.bestOnlyGender = bestOnlyRank
                        bestOnlyRank += 1
                        bestOnly.insert(r.name!)
                    }
                }
                
                //campGender rank
                let campGenderSort = items.sorted(by: {($0.campName, $0.gender
                    , $0.valueFor(u.activity.rawValue, u.unit.rawValue) ) > ($1.campName,$1.gender, $1.valueFor( u.activity.rawValue,  u.unit.rawValue))})
                
                var currentCampGender = ""
                for r in campGenderSort{
                    let campGender: String = r.campName + r.gender
                    if campGender != currentCampGender{
                        rank = 1
                        currentCampGender =  campGender
                    }
                    r.rankFor( u.activity.rawValue,  u.unit.rawValue).campGender = rank
                    rank += 1
                }
                
                //camp rank
                let campSort = items.sorted(by: {($0.campName, $0.valueFor( u.activity.rawValue, u.unit.rawValue) ) > ($1.campName, $1.valueFor( u.activity.rawValue,  u.unit.rawValue))})
                
                
                var currentCamp: String = ""
                for r in campSort{
                    if r.campName != currentCamp {
                        // reset
                        rank = 1
                        currentCamp = r.campName
                    }
                    r.rankFor( u.activity.rawValue,  u.unit.rawValue).camp = rank
                    rank += 1
                }
                
                //participant rank
                let participantSort = items.sorted(by: {($0.name!, $0.valueFor( u.activity.rawValue, u.unit.rawValue)) > ($1.name!, $1.valueFor( u.activity.rawValue,  u.unit.rawValue))})
                
                var currenParticipant: String = ""
                for r in participantSort{
                    if r.name != currenParticipant {
                        // reset
                        rank = 1
                        currenParticipant = r.name!
                    }
                    r.rankFor( u.activity.rawValue,  u.unit.rawValue).participant = rank
                    rank += 1
                }
                
                //role rank
                let roleSort = items.sorted(by: {($0.campRole, $0.valueFor( u.activity.rawValue,  u.unit.rawValue)) > ($1.campRole, $1.valueFor( u.activity.rawValue,  u.unit.rawValue))})
                
                var currentRole: String = ""
                for r in roleSort{
                    if r.campRole != currentRole {
                        // reset
                        rank = 1
                        currentRole = r.campRole
                    }
                    r.rankFor( u.activity.rawValue,  u.unit.rawValue).role = rank
                    rank += 1
                }
            }
        }
        

    }
    
    
}
