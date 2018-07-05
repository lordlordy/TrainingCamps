//
//  CampGroupTreeNodeGenerator.swift
//  TrainingCamps
//
//  Created by Steven Lord on 02/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class CampGroupTreeNodeGenerator: TreeNodeGenerator{

    
    private var campGroup: CampGroup
    private var generator: TreeGenerator = TreeGenerator()
    
    init(_ cg: CampGroup){
        campGroup = cg
    }
    
    func treeOrders() -> [String] {
        return TreeGenerator.TreeOrder.All.map({$0.rawValue})
    }
    
    func generateTree(inOrder: String, nodesShow: Maths.Aggregator, participantFilter: ParticipantFilter) -> [TreeNode] {
        if let order = TreeGenerator.TreeOrder(rawValue: inOrder){
            return generator.generateTree(forGroup: campGroup, forCamps: nil, andOrder: order, nodesShow: nodesShow, participantFilter: participantFilter)
        }else{
            return []
        }

    }
    
}
