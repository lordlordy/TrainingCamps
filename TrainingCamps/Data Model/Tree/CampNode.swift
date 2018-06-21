//
//  CampNode.swift
//  TrainingCamps
//
//  Created by Steven Lord on 14/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class CampNode: TreeNodeImplementation{
    
    override var totalKM: Double {return trainingNode.totalKM}
    override var swimKM: Double {return trainingNode.swimKM}
    override var bikeKM: Double {return trainingNode.bikeKM}
    override var runKM: Double {return trainingNode.runKM}
    
    override var totalSeconds: Double {return trainingNode.totalSeconds}
    override var swimSeconds: Double {return trainingNode.swimSeconds}
    override var bikeSeconds: Double {return trainingNode.bikeSeconds}
    override var runSeconds: Double {return trainingNode.runSeconds}
    
    override var dayCount: Int {return trainingNode.dayCount}
    override var raceCount: Int {return racingNode.raceCount}
    
    override var completionCount: Int{ return countTrainingCompletions()}
    
    private var trainingNode: TreeNode
    private var racingNode: TreeNode
    
    init(name: String, date: Date, training: TreeNode, races: TreeNode){
        trainingNode = training
        racingNode = races
        super.init(name: name, date: date)
        children = [trainingNode, racingNode]
    }
    
}
