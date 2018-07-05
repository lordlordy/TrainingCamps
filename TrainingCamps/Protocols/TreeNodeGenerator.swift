//
//  TreeNodeGenerator.swift
//  TrainingCamps
//
//  Created by Steven Lord on 02/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

protocol TreeNodeGenerator{
    func treeOrders() -> [String]
    func generateTree(inOrder: String, nodesShow: Maths.Aggregator, participantFilter: ParticipantFilter) -> [TreeNode]

}
