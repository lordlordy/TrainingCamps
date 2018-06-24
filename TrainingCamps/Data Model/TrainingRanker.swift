//
//  TrainingRanker.swift
//  TrainingCamps
//
//  Created by Steven Lord on 23/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class TrainingRanker{
    
    var rankUnits: [(activity: Activity, unit: Unit)]{
        var result: [(activity: Activity, unit: Unit)] = []
        result.append((Activity.total, unit: Unit.Seconds))
        result.append((Activity.total, unit: Unit.KM))
        result.append((Activity.total, unit: Unit.Ascent))
        result.append((Activity.swim, unit: Unit.Seconds))
        result.append((Activity.swim, unit: Unit.KM))
        result.append((Activity.bike, unit: Unit.Seconds))
        result.append((Activity.bike, unit: Unit.KM))
        result.append((Activity.bike, unit: Unit.Ascent))
        result.append((Activity.run, unit: Unit.Seconds))
        result.append((Activity.run, unit: Unit.KM))
        result.append((Activity.run, unit: Unit.Ascent))
        return result
    }
    
    func rank(_ campGroup: CampGroup){
        let start = Date()
        rankDays(campGroup)
        print("Training ranking took \(Int(Date().timeIntervalSince(start)))s")
    }
    
    fileprivate func rankDays(_ campGroup: CampGroup) {
        let days: [ParticipantDay] = campGroup.participantDaysArray()
        for u in rankUnits{
            let sortedDays: [ParticipantDay] = days.sorted(by: {$0.valueFor( u.activity, u.unit) > $1.valueFor( u.activity,  u.unit)})
            var rank: Int32 = 1
            
            //overall rank
            for d in sortedDays{
                d.rankFor( u.activity, u.unit).overall = rank
                rank += 1
            }
            
            //gender rank
            let genderSort = days.sorted(by: {($0.campParticipant!.participant!.gender!, $0.valueFor( u.activity, u.unit)) < ($1.campParticipant!.participant!.gender!, $1.valueFor( u.activity,  u.unit))})
            
            var currentGender = ""
            for r in genderSort{
                if r.campParticipant?.participant?.gender != currentGender{
                    rank = 1
                    currentGender = r.campParticipant!.participant!.gender!
                }
                r.rankFor( u.activity,  u.unit).gender = rank
                rank += 1
            }
            
            //campGender rank
            let campGenderSort = days.sorted(by: {($0.campParticipant!.camp!.campName!, $0.campParticipant!.participant!.gender!, $0.valueFor(u.activity, u.unit) ) < ($1.campParticipant!.camp!.campName!,$1.campParticipant!.participant!.gender!, $1.valueFor( u.activity,  u.unit))})
            
            var currentCampGender = ""
            for r in campGenderSort{
                let campGender: String = r.campParticipant!.camp!.campName! + r.campParticipant!.participant!.gender!
                if campGender != currentCampGender{
                    rank = 1
                    currentCampGender =  campGender
                }
                r.rankFor( u.activity,  u.unit).campGender = rank
                rank += 1
            }
            
            //camp rank
            let campSort = days.sorted(by: {($0.campParticipant!.camp!.campName!, $0.valueFor( u.activity, u.unit) ) < ($1.campParticipant!.camp!.campName!, $1.valueFor( u.activity,  u.unit))})
            
            
            var currentCamp: String = ""
            for r in campSort{
                if r.campParticipant!.camp!.campName! != currentCamp {
                    // reset
                    rank = 1
                    currentCamp = r.campParticipant!.camp!.campName!
                }
                r.rankFor( u.activity,  u.unit).camp = rank
                rank += 1
            }
            
            //participant rank
            let participantSort = days.sorted(by: {($0.campParticipant!.participant!.uniqueName!, $0.valueFor( u.activity, u.unit)) < ($1.campParticipant!.participant!.uniqueName!, $1.valueFor( u.activity,  u.unit))})
            
            var currenParticipant: String = ""
            for r in participantSort{
                if r.campParticipant!.participant!.uniqueName! != currenParticipant {
                    // reset
                    rank = 1
                    currenParticipant = r.campParticipant!.participant!.uniqueName!
                }
                r.rankFor( u.activity,  u.unit).participant = rank
                rank += 1
            }
            
            //role rank
            let roleSort = days.sorted(by: {($0.campParticipant!.role!, $0.valueFor( u.activity,  u.unit)) < ($1.campParticipant!.role!, $1.valueFor( u.activity,  u.unit))})
            
            var currentRole: String = ""
            for r in roleSort{
                if r.campParticipant!.role! != currentRole {
                    // reset
                    rank = 1
                    currentRole = r.campParticipant!.role!
                }
                r.rankFor( u.activity,  u.unit).role = rank
                rank += 1
            }
        }
    }
    

}
