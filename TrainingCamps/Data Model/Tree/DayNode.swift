//
//  DayNode.swift
//  TrainingCamps
//
//  Created by Steven Lord on 14/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class DayNode: NSObject, TreeNodeOLD{
    
    func addChild(_ child: TreeNodeOLD) {
        print("Shouldn't be trying to add a node to a Day")
    }
    
    var children: [TreeNodeOLD] {return []}
    var leaves: [TreeNodeOLD] { return [self]}
    
    var name: String 
    
    var date: Date { return day.day!.date!}
    
    var campComplete: Bool{ return day.dayComplete }
    var completionStatus: String { return campComplete ? "Yes" : "No" }
    var completionCount: Int{ return campComplete ? 1 : 0 }
    
    var totalKM:        Double {return day.totalKM}
    var swimKM:         Double {return day.swimKM}
    var bikeKM:         Double {return day.bikeKM}
    var runKM:          Double {return day.runKM}
    var totalSeconds:   Double {return day.totalSeconds}
    var swimSeconds:    Double {return day.swimSeconds}
    var bikeSeconds:    Double {return day.bikeSeconds}
    var runSeconds:     Double {return day.runSeconds}
    
    var rank: Int = 0
    var swimRank: Int = 0
    var bikeRank: Int = 0
    var runRank: Int = 0
    
    var childCount: Int {return 0}
    var dayCount: Int {return 1}
    var raceCount: Int {return 0}
    
    var day: ParticipantDay
    
    init(day: ParticipantDay){
        self.day = day
        name = day.campParticipant?.participant?.displayName ?? "NAME NOT SET FOR DAY NODE"
    }
    
    
    
}
