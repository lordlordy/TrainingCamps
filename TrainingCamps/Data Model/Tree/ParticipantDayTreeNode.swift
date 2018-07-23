//
//  ParticipantDayTreeNode.swift
//  TrainingCamps
//
//  Created by Steven Lord on 27/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class ParticipantDayTreeNode: NSObject, TreeNode{
    
    
    var totalTimePercentile: Double{
        return day.campParticipant?.camp?.campGroup?.percentile(forActivity: .total, andUnit: .Seconds, isCamp: false, withValue: day.totalSeconds) ?? 0.0
    }
    

    func leavesShow(trainingLeafNameType trainingShow: String, racingLeafNameType racingShow: String) {
        if let type = TrainingLeafNameType(rawValue: trainingShow){
            participantDayNameType = type
        }
    }
    
    
    @objc dynamic var height: Int { return 0 } // this is a leave node
    @objc dynamic var nodeType: String { return TreeNodeType.TrainingDay.rawValue}
    
    var camp: String? { return day.campName}
    var gender: String? { return day.campParticipant?.participant?.gender}
    
    
    private var day: ParticipantDay
    
    init(_ pd: ParticipantDay){
        day = pd
        super.init()
    }
    
    @objc var children:             [TreeNode] { return [] }
    @objc var childCount:           Int { return 0}
    @objc var treeNodeName:         String? {
        switch participantDayNameType{
        case .ParticipantName:
            return day.campParticipant?.participant?.displayName
        case .DayOfWeek:
            if let d = date{
                let df = DateFormatter()
                df.dateFormat = DateFormatString.DayOfWeekOnly.rawValue
                return df.string(from: d)
            }else{
                return "Not Set"
            }
        }
    }
    
    @objc var date:                 Date? {return day.day?.date}
    @objc var totalAscentMetres:    Double {return day.totalAscentMetres}
    @objc var bikeAscentMetres:     Double {return day.bikeAscentMetres}
    @objc var runAscentMetres:      Double {return day.runAscentMetres}
    @objc var totalKM:              Double {return day.totalKM}
    @objc var swimKM:               Double {return day.swimKM}
    @objc var bikeKM:               Double {return day.bikeKM}
    @objc var runKM:                Double {return day.runKM}
    @objc var totalSeconds:         Double {return day.totalSeconds}
    @objc var swimSeconds:          Double {return day.swimSeconds}
    @objc var bikeSeconds:          Double {return day.bikeSeconds}
    @objc var runSeconds:           Double {return day.runSeconds}
    @objc var role:                 String? {return day.campParticipant?.role}
    @objc var completed:            Bool { return day.dayComplete}
    @objc var includeInAggregation: Bool {return true}
    @objc var daysCount:            Double {return 1.0} // double as when we average can get a decimal
    @objc var raceResultsCount:     Double {return 0.0} // double as when we average can get a decimal
    
    @objc var rankTotalAscentMetres:    Int = 0
    @objc var rankTotalKM:              Int = 0
    @objc var rankTotalSeconds:         Int = 0
    @objc var rankSwimSeconds:          Int = 0
    @objc var rankSwimKM:               Int = 0
    @objc var rankBikeAscent:           Int = 0
    @objc var rankBikeKM:               Int = 0
    @objc var rankBikeSeconds:          Int = 0
    @objc var rankRunAscent:            Int = 0
    @objc var rankRunKM:                Int = 0
    @objc var rankRunSeconds:           Int = 0
    

    
    func rankChildren() {
        //do nothing - no children
    }

    private var participantDayNameType: TrainingLeafNameType = TrainingLeafNameType.ParticipantName
    
}
