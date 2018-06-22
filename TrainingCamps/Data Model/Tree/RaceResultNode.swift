//
//  RaceResultNode.swift
//  TrainingCamps
//
//  Created by Steven Lord on 14/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class RaceResultNode: NSObject, TreeNode{
    
    func addChild(_ child: TreeNode) {
        print("Shouldn't be adding a child to a race result")
    }
    
    var children: [TreeNode] {return []}
    var leaves: [TreeNode] {return [self]}
    
    var name: String
    var date: Date  {return raceResult.race!.date!}
    
    var campComplete: Bool{ return raceResult.raceComplete }
    var completionStatus: String{ return campComplete ? "Yes":"No"}
    var completionCount: Int{ return campComplete ? 1 : 0}
    
    
    var totalKM:    Double {return swimKM + bikeKM + runKM}
    var swimKM:     Double {return raceResult.race?.raceDefinition?.swimKM ?? 0.0}
    var bikeKM:     Double {return raceResult.race?.raceDefinition?.bikeKM ?? 0.0}
    var runKM:      Double {return raceResult.race?.raceDefinition?.runKM ?? 0.0}
    
    var totalSeconds:   Double {return swimSeconds + bikeSeconds + runSeconds}
    var swimSeconds:    Double {return raceResult.swimSeconds}
    var bikeSeconds:    Double {return raceResult.bikeSeconds}
    var runSeconds:     Double {return raceResult.runSeconds}
    
    var rank: Int = 0
    var swimRank: Int = 0
    var bikeRank: Int = 0
    var runRank: Int = 0
    
    var childCount: Int {return 0}
    var dayCount: Int {return 0}
    var raceCount: Int {return 1}
    
    var raceResult: RaceResult
    
    init(raceResult: RaceResult){
        self.raceResult = raceResult
        name = raceResult.campParticipant?.participant?.displayName ?? "NAME NOT SET IN RaceResultNode"
        rank = Int(raceResult.rank)
        swimRank = Int(raceResult.swimRank.camp)
        bikeRank = Int(raceResult.bikeRank.camp)
        runRank = Int(raceResult.runRank.camp)
    }
    
}
