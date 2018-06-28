//
//  TreeNode.swift
//  TrainingCamps
//
//  Created by Steven Lord on 14/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

@objc protocol TreeNodeOLD {
    func addChild(_ child: TreeNodeOLD)
    
    @objc var children: [TreeNodeOLD] {get}
    @objc var leaves: [TreeNodeOLD] {get}
    
    @objc var childCount: Int {get}
    @objc var dayCount: Int {get}
    @objc var raceCount: Int {get}
    
    @objc var campComplete: Bool {get}
    @objc var completionStatus: String {get}
    @objc var completionCount: Int {get}
    
    @objc var name: String {get set}
    @objc var date: Date {get}
    
    @objc var totalKM: Double {get}
    @objc var swimKM: Double {get}
    @objc var bikeKM: Double {get}
    @objc var runKM: Double {get}
    
    @objc var totalSeconds: Double {get}
    @objc var swimSeconds: Double {get}
    @objc var bikeSeconds: Double {get}
    @objc var runSeconds: Double {get}
    
    @objc var rank: Int {get set}
    @objc var swimRank: Int {get set}
    @objc var bikeRank: Int {get set}
    @objc var runRank: Int {get set}
    
}
