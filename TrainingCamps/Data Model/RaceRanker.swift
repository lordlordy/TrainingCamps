//
//  RaceRanker.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class RaceRanker{

    // relays are excluded except for the camp rank
    
    func rank(_ race: Race){
        let start = Date()
        
        for i in rankUnits(forRace: race){
            rankFor(i.activity, i.unit, race.raceDefinition!)
        }
        
        print("Ranking took \(Int(Date().timeIntervalSince(start)))s")
        
    }
    
    fileprivate func rankFor(_ activity: Activity, _ unit: Unit, _ raceDefinition: RaceDefinition) {
        let key: String = activity.rawValue + unit.rawValue
        if let results = raceDefinition.allRaceResults.allObjects as? [RaceResult]{

            //set ranks to last if race not completed
            let nonCompleters = results.filter({$0.raceCompletionStatus! != RaceCompletionStatus.Y.rawValue})
            let completers = results.filter({$0.raceCompletionStatus! == RaceCompletionStatus.Y.rawValue})
            for i in nonCompleters{
                let r: Rank = i.rankFor(activity: activity, unit: unit)
                r.overall = Constants.lastPlaceRank
                r.camp = Constants.lastPlaceRank
                r.gender = Constants.lastPlaceRank
                r.participant = Constants.lastPlaceRank
                r.role = Constants.lastPlaceRank
                r.campGender = Constants.lastPlaceRank
            }
            
            //same for relays. The camp ranks will be orriden later
            for i in completers.filter({$0.isRelay}){
                let r: Rank = i.rankFor(activity: activity, unit: unit)
                r.overall = Constants.lastPlaceRank
                r.camp = Constants.lastPlaceRank
                r.gender = Constants.lastPlaceRank
                r.participant = Constants.lastPlaceRank
                r.role = Constants.lastPlaceRank
                r.campGender = Constants.lastPlaceRank
            }
            
            let completersNoRelays = completers.filter({!$0.isRelay})
    
            var rank: Int32 = 1
            var bestOnlyRank: Int32 = 1
            var bestOnly: Set<String> = Set<String>()
            
            //participant rank
            var currentParticipant: String = ""
            for r in completersNoRelays.sorted(by: {($0.campParticipant!.participant!.uniqueName!, $0.value(forKey: key) as! Double) < ($1.campParticipant!.participant!.uniqueName!, $1.value(forKey: key) as! Double)}){
                if r.campParticipant!.participant!.uniqueName! != currentParticipant {
                    // reset
                    rank = 1
                    currentParticipant = r.campParticipant!.participant!.uniqueName!
                }
                r.rankFor(activity: activity, unit: unit).participant = rank
                rank += 1
            }
            
            //order results with a participants in their rank order. This is to deal with the case where a participant has two times the same - we want to ensure the best only rank is placed in the same instance
            rank = 1
            //overall rank
            for r in completersNoRelays.sorted(by: {(($0.value(forKey: key) as! Double), $0.rankParticipant) < (($1.value(forKey:key) as! Double), $1.rankParticipant)}){
                
                let rankItem: Rank = r.rankFor(activity: activity, unit: unit)
                rankItem.overall = rank
                rank += 1
                if bestOnly.contains(r.campParticipant!.participant!.displayName){
                    rankItem.bestOnly = Constants.lastPlaceRank
                }else{
                    rankItem.bestOnly = bestOnlyRank
                    bestOnlyRank += 1
                    bestOnly.insert(r.campParticipant!.participant!.displayName)
                }
            }
            
            bestOnlyRank = 1
            bestOnly = Set<String>()
            
            //Female ranks
            for r in completersNoRelays.filter({$0.campParticipant!.participant!.gender! == Gender.Female.rawValue}).sorted(by: {($0.value(forKey: key) as! Int, $0.rankParticipant) < ( $1.value(forKey: key) as! Int, $0.rankParticipant)}){
                
                let rankItem: Rank = r.rankFor(activity: activity, unit: unit)
                rankItem.gender = rank
                rank += 1
                if bestOnly.contains(r.campParticipant!.participant!.displayName){
                    rankItem.bestOnlyGender = Constants.lastPlaceRank
                }else{
                    rankItem.bestOnlyGender = bestOnlyRank
                    bestOnlyRank += 1
                    bestOnly.insert(r.campParticipant!.participant!.displayName)
                }
            }
            
            bestOnlyRank = 1
            bestOnly = Set<String>()
            
            //Male ranks
            for r in completersNoRelays.filter({$0.campParticipant!.participant!.gender! == Gender.Male.rawValue}).sorted(by: {($0.value(forKey: key) as! Int, $0.rankParticipant) < ( $1.value(forKey: key) as! Int, $0.rankParticipant)}){
                
                let rankItem: Rank = r.rankFor(activity: activity, unit: unit)
                rankItem.gender = rank
                rank += 1
                if bestOnly.contains(r.campParticipant!.participant!.displayName){
                    rankItem.bestOnlyGender = Constants.lastPlaceRank
                }else{
                    rankItem.bestOnlyGender = bestOnlyRank
                    bestOnlyRank += 1
                    bestOnly.insert(r.campParticipant!.participant!.displayName)
                }
            }

            //campGender rank
            var currentCampGender = ""
            for r in completers.sorted(by: {($0.campParticipant!.camp!.campName!, $0.campParticipant!.participant!.gender!, $0.value(forKey: key) as! Double) < ($1.campParticipant!.camp!.campName!,$1.campParticipant!.participant!.gender!, $1.value(forKey: key) as! Double)}){
                let campGender: String = r.campParticipant!.camp!.campName! + r.campParticipant!.participant!.gender!
                if campGender != currentCampGender{
                    rank = 1
                    currentCampGender =  campGender
                }
                r.rankFor(activity: activity, unit: unit).campGender = rank
                rank += 1
            }
            
            //camp rank
            var currentCamp: String = ""
            for r in completers.sorted(by: {($0.campParticipant!.camp!.campName!, $0.value(forKey: key) as! Double) < ($1.campParticipant!.camp!.campName!, $1.value(forKey: key) as! Double)}){
                if r.campParticipant!.camp!.campName! != currentCamp {
                    // reset
                    rank = 1
                    currentCamp = r.campParticipant!.camp!.campName!
                }
                r.rankFor(activity: activity, unit: unit).camp = rank
                rank += 1
            }
            
            //role rank
            var currentRole: String = ""
            for r in completersNoRelays.sorted(by: {($0.campParticipant!.role!, $0.value(forKey: key) as! Double) < ($1.campParticipant!.role!, $1.value(forKey: key) as! Double)}){
                if r.campParticipant!.role! != currentRole {
                    // reset
                    rank = 1
                    currentRole = r.campParticipant!.role!
                }
                r.rankFor(activity: activity, unit: unit).role = rank
                rank += 1
            }
        }
    }
    
    private func rankUnits(forRace race: Race) -> [(activity: Activity, unit: Unit)]{
        var units: [(activity: Activity, unit: Unit)] = []
        let u: Unit = Unit.Seconds
        
        units.append((Activity.total, u))
        
        if race.includesSwim                        { units.append((Activity.swim, u))}
        if race.includesBike                        { units.append((Activity.bike, u))}
        if race.includesRun                         { units.append((Activity.run, u))}
        if race.raceDefinition!.disciplineCount > 1 { units.append((Activity.t1,u))}
        if race.raceDefinition!.disciplineCount > 2 { units.append((Activity.t2,u))}
        if race.isGuessYourTime                     { units.append((Activity.guessDifference,u))}
        if race.isHandicap                          { units.append((Activity.handicapAdjusted,u))}

        return units
    }

    
}
