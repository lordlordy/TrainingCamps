//
//  TreeNode.swift
//  TrainingCamps
//
//  Created by Steven Lord on 24/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

@objc protocol TreeNode {
    @objc var children:             [TreeNode] { get }
    @objc var childCount:           Int {get}
    @objc var treeNodeName:         String? {get}
    @objc var date:                 Date? {get}
    @objc var totalAscentMetres:    Double {get}
    @objc var bikeAscentMetres:     Double {get}
    @objc var runAscentMetres:      Double {get}
    @objc var totalKM:              Double {get}
    @objc var swimKM:               Double {get}
    @objc var bikeKM:               Double {get}
    @objc var runKM:                Double {get}
    @objc var totalSeconds:         Double {get}
    @objc var swimSeconds:          Double {get}
    @objc var bikeSeconds:          Double {get}
    @objc var runSeconds:           Double {get}
    @objc var role:                 String? {get}
    @objc var completed:            Bool { get}
    @objc var includeInAggregation: Bool {get}
    @objc var daysCount:            Double {get} // double as when we average can get a decimal
    @objc var raceResultsCount:     Double {get} // double as when we average can get a decimal
    
    @objc var rankTotalAscentMetres:    Int { get set}
    @objc var rankTotalKM:              Int { get set}
    @objc var rankTotalSeconds:         Int { get set}
    @objc var rankSwimSeconds:          Int { get set}
    @objc var rankSwimKM:               Int { get set}
    @objc var rankBikeAscent:           Int { get set}
    @objc var rankBikeKM:               Int { get set}
    @objc var rankBikeSeconds:          Int { get set}
    @objc var rankRunAscent:            Int { get set}
    @objc var rankRunKM:                Int { get set}
    @objc var rankRunSeconds:           Int { get set}
    
    @objc var camp: String? {get}
    @objc var gender: String? {get}

    func leavesShow(participantName show: Bool)
    func rankChildren()
    
}
