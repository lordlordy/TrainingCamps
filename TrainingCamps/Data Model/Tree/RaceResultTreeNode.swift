//
//  RaceResultTreeNode.swift
//  TrainingCamps
//
//  Created by Steven Lord on 27/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class RaceResultTreeNode: NSObject, TreeNode{
    
    
    var totalTimePercentile: Double{
        return result.race?.raceDefinition?.percentile(forResult: result) ?? 0.0
    }
    
    var nodeType: String {return TreeNodeType.RaceResult.rawValue}
    
    var camp: String? { return result.campName}
    var gender: String? { return result.campParticipant?.participant?.gender}
    
    @objc dynamic var height: Int { return 0 } // this is a leave node

    
    private var result: RaceResult
    
    init(_ rd: RaceResult){
        result = rd
        super.init()
    }
    
    @objc var children:             [TreeNode] { return [] }
    @objc var childCount:           Int {return 0}
    @objc var treeNodeName:         String? {
        switch raceResultNameType{
        case .ParticipantName:
            return result.campParticipant?.participant?.displayName
        case .RaceName:
            return result.race?.raceDefinition?.name
        case .CampName:
            return result.campParticipant?.camp?.campName
            
        }
    }
    @objc var date:                 Date? {return result.race?.date}
    @objc var totalAscentMetres:    Double {return 0.0}
    @objc var bikeAscentMetres:     Double {return 0.0}
    @objc var runAscentMetres:      Double {return 0.0}
    @objc var totalKM:              Double {return swimKM + bikeKM + runKM}
    @objc var swimKM:               Double {return result.race?.raceDefinition?.swimKM ?? 0.0}
    @objc var bikeKM:               Double {return result.race?.raceDefinition?.bikeKM ?? 0.0}
    @objc var runKM:                Double {return result.race?.raceDefinition?.runKM ?? 0.0}
    @objc var totalSeconds:         Double {return result.totalSeconds}
    @objc var swimSeconds:          Double {return result.swimSeconds}
    @objc var bikeSeconds:          Double {return result.bikeSeconds}
    @objc var runSeconds:           Double {return result.runSeconds}
    @objc var role:                 String? {return result.campParticipant?.role ?? "Not Set"}
    @objc var completed:            Bool { return (result.completionStatus == RaceCompletionStatus.Y.rawValue || result.completionStatus == RaceCompletionStatus.Ydnf.rawValue)}
    @objc var includeInAggregation: Bool {return true}
    @objc var daysCount:            Double {return 0.0} // double as when we average can get a decimal
    @objc var raceResultsCount:     Double {return 1.0} // double as when we average can get a decimal
    
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
    
    func leavesShow(trainingLeafNameType trainingShow: String, racingLeafNameType racingShow: String){
        if let type = RacingLeafNameType(rawValue: racingShow){
            raceResultNameType = type
        }
    }

    func rankChildren() {
        //do nothing - no children
    }

    
    private var raceResultNameType: RacingLeafNameType = RacingLeafNameType.ParticipantName
}

