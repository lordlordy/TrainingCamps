//
//  Day+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 14/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension Day{

    
    
    //MARK:- TreeNode
//    var children: [TreeNode] { return participantDays?.allObjects as? [TreeNode] ?? []}
//    
//    var treeNodeName: String? {
//        let df: DateFormatter = DateFormatter()
//        df.dateFormat = DateFormatString.DayOfWeekOnly.rawValue
//        if let d = date{
//            return df.string(from: d)
//        }else{
//            return "not set"
//        }
//    }
    
    
    @objc var totalKM: Double { return swimKM + bikeKM + runKM }
    @objc var swimKM: Double { return participantDaysArray().reduce(0.0, {$0 + $1.swimKM})}
    @objc var bikeKM: Double { return participantDaysArray().reduce(0.0, {$0 + $1.bikeKM})}
    @objc var runKM: Double { return participantDaysArray().reduce(0.0, {$0 + $1.runKM})}
    
    @objc var bricks: Int { return participantDaysArray().reduce(0, {$0 + ($1.brick ? 1 : 0)})}
    
    @objc var totalAscentMetres: Double { return  bikeAscentMetres + runAscentMetres }
    @objc var bikeAscentMetres: Double { return participantDaysArray().reduce(0.0, {$0 + $1.bikeAscentMetres})}
    @objc var runAscentMetres: Double { return participantDaysArray().reduce(0.0, {$0 + $1.runAscentMetres})}
    
    @objc var totalSeconds: Double {return swimSeconds + bikeSeconds + runSeconds}
    @objc var swimSeconds: Double { return participantDaysArray().reduce(0.0, {$0 + $1.swimSeconds})}
    @objc var bikeSeconds: Double { return participantDaysArray().reduce(0.0, {$0 + $1.bikeSeconds})}
    @objc var runSeconds: Double { return participantDaysArray().reduce(0.0, {$0 + $1.runSeconds})}
    
//    func leavesShow(participantName show: Bool) {
//        for c in children{
//            c.leavesShow(participantName: show)
//        }
//    }
    
    @objc var participantDaysCount: Int { return participantDays?.count ?? 0}
    @objc var noParticipantDays: Bool { return participantDaysCount == 0}
    
    @objc dynamic var dateString: String{
        get{
            let df: DateFormatter = DateFormatter()
            df.dateFormat =  DateFormatString.ValidCampDate.rawValue
            if let d = date{
                return df.string(from: d)
            }else{
                return "NOT SET"
            }
        }
        set{
            let df: DateFormatter = DateFormatter()
            df.dateFormat =  DateFormatString.ValidCampDate.rawValue
            date = df.date(from: newValue)
        }
    }
    
    
    func trainingComplete(particpantDay pd: ParticipantDay) -> Bool{
        return swimComplete(particpantDay:pd) && bikeComplete(particpantDay:pd) && runComplete(particpantDay:pd)
    }
    
    func swimComplete(particpantDay pd: ParticipantDay) -> Bool{
        return (pd.swimWildcardUsed && pd.swimSeconds >= completionSwimSecondsWithWildcard) || (pd.swimSeconds >= completionSwimSeconds)
    }

    func bikeComplete(particpantDay pd: ParticipantDay) -> Bool{
        return (pd.bikeWildcardUsed && pd.bikeKM >= completionBikeKMWithWildcard) || (pd.bikeKM >= completionBikeKM)
    }
    
    func runComplete(particpantDay pd: ParticipantDay) -> Bool{
        return (pd.runWildcardUsed && pd.runSeconds >= completionRunSecondsWithWildcard) || (pd.runSeconds >= completionRunSeconds)
    }
    
    func swimWildCardEarned(forParticipantDay pd: ParticipantDay) -> Bool{
        return pd.swimSeconds >= earnWildcardSwimSeconds
    }
    
    func bikeWildCardEarned(forParticipantDay pd: ParticipantDay) -> Bool{
        return pd.bikeKM >= earnWildcardBikeKM
    }

    func runWildCardEarned(forParticipantDay pd: ParticipantDay) -> Bool{
        return pd.runSeconds >= earnWildcardRunSeconds
    }
    
    func participantDaysArray() -> [ParticipantDay]{
        return participantDays?.allObjects as? [ParticipantDay] ?? []
    }
    
}
