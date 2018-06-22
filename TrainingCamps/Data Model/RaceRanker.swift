//
//  RaceRanker.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class RaceRanker{

    struct Ranking{
        var overallRank: Int
        var genderRank: Int
        var campRank: Int
        var participantRank: Int
        var roleRank: Int
        var unit: Unit
        var activity: Activity
    }
    
    

    
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
            
            
            let sortedResults = completers.sorted(by:{($0.value(forKey: key) as! Double) < ($1.value(forKey:key) as! Double)})
            
    
            var rank: Int32 = 1
            
            //overall rank
            for r in sortedResults{
                r.rankFor(activity: activity, unit: unit).overall = rank
                rank += 1
            }
            
            //gender rank
            let genderSort = completers.sorted(by: {($0.campParticipant!.participant!.gender!, $0.value(forKey: key) as! Double) < ($1.campParticipant!.participant!.gender!, $1.value(forKey: key) as! Double)})
            
            var currentGender = ""
            for r in genderSort{
                if r.campParticipant?.participant?.gender != currentGender{
                    rank = 1
                    currentGender = r.campParticipant!.participant!.gender!
                }
                r.rankFor(activity: activity, unit: unit).gender = rank
                rank += 1
            }

            //campGender rank
            let campGenderSort = completers.sorted(by: {($0.campParticipant!.camp!.campName!, $0.campParticipant!.participant!.gender!, $0.value(forKey: key) as! Double) < ($1.campParticipant!.camp!.campName!,$1.campParticipant!.participant!.gender!, $1.value(forKey: key) as! Double)})
            
            var currentCampGender = ""
            for r in campGenderSort{
                let campGender: String = r.campParticipant!.camp!.campName! + r.campParticipant!.participant!.gender!
                if campGender != currentCampGender{
                    rank = 1
                    currentCampGender =  campGender
                }
                r.rankFor(activity: activity, unit: unit).campGender = rank
                rank += 1
            }
            
            //camp rank
            let campSort = completers.sorted(by: {($0.campParticipant!.camp!.campName!, $0.value(forKey: key) as! Double) < ($1.campParticipant!.camp!.campName!, $1.value(forKey: key) as! Double)})
            
            
            var currentCamp: String = ""
            for r in campSort{
                if r.campParticipant!.camp!.campName! != currentCamp {
                    // reset
                    rank = 1
                    currentCamp = r.campParticipant!.camp!.campName!
                }
                r.rankFor(activity: activity, unit: unit).camp = rank
                rank += 1
            }
            
            //participant rank
            let participantSort = completers.sorted(by: {($0.campParticipant!.participant!.uniqueName!, $0.value(forKey: key) as! Double) < ($1.campParticipant!.participant!.uniqueName!, $1.value(forKey: key) as! Double)})
            
            var currenParticipant: String = ""
            for r in participantSort{
                if r.campParticipant!.participant!.uniqueName! != currenParticipant {
                    // reset
                    rank = 1
                    currenParticipant = r.campParticipant!.participant!.uniqueName!
                }
                r.rankFor(activity: activity, unit: unit).participant = rank
                rank += 1
            }
            
            //role rank
            let roleSort = completers.sorted(by: {($0.campParticipant!.role!, $0.value(forKey: key) as! Double) < ($1.campParticipant!.role!, $1.value(forKey: key) as! Double)})
            
            var currentRole: String = ""
            for r in roleSort{
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
