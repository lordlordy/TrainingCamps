//
//  TreeGeneratorParticipant.swift
//  TrainingCamps
//
//  Created by Steven Lord on 02/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class TreeGeneratorParticipant: TreeNodeGenerator{
    
    enum TreeOrder: String{
        case standard = "Athlete -> Camp -> Training"
        static var All: [TreeOrder] = [standard]
    }
    
    func treeOrders() -> [String] {
        return TreeOrder.All.map({$0.rawValue})
    }
    
    func generateTree(inOrder: String, nodesShow: Maths.Aggregator, participantFilter: ParticipantFilter) -> [TreeNode] {
        filter = participantFilter
        aggregator = nodesShow
        var result: [TreeNode] = []
        
        if let order = TreeOrder(rawValue: inOrder){
            switch order{
            case .standard: result = generateStandardTree()
            }
        }else{
            result = generateStandardTree()
        }
        
        for r in result{
            r.rankChildren()
        }
        
        return result
    }
    
    private func generateStandardTree() -> [TreeNode]{
        let rootNode: TreeNodeEditable = newGenericTreeNode(name: "All", date: nil, true, nil, TreeNodeType.Root)
        
        for p in participants{
            let pNode: TreeNodeEditable = newGenericTreeNode(name: p.displayName, date: p.firstCampDate, true, nil, TreeNodeType.Participant)
            rootNode.addChild(pNode)
            for c in p.campParticipations?.allObjects as? [CampParticipant] ?? []{
                let campNode: TreeNodeEditable = newGenericTreeNode(name: c.campName, date: c.camp?.campStart, true, c.campName, TreeNodeType.Camp)
                pNode.addChild(campNode)
                let trainingNode: TreeNodeEditable = newGenericTreeNode(name: "Training", date: c.camp?.campStart, true, c.campName, TreeNodeType.Training)
                campNode.addChild(trainingNode)
                for d in c.getDays(){
                    trainingNode.addChild(ParticipantDayTreeNode(d))
                }
                let racingNode: TreeNodeEditable = newGenericTreeNode(name: "Races", date: c.camp?.campStart, false, c.campName, TreeNodeType.Racing)
                campNode.addChild(racingNode)
                for r in c.getRaces(){
                    racingNode.addChild(RaceResultTreeNode(r))
                }
            }
        }
        rootNode.rankChildren()
        rootNode.leavesShow(participantName: false)
        if rootNode.children.count == 1{
            return [rootNode.children[0]]
        }
        
        return [rootNode]
    }
    
    private var participants: [Participant] = []
    private var aggregator: Maths.Aggregator = Maths.Aggregator.Sum
    private var filter: ParticipantFilter = ParticipantFilter.All

    
    init(_ p: [Participant]){
        participants = p
    }
    
    private func newGenericTreeNode(name n: String, date d: Date?, _ aggregate: Bool, _ camp: String?, _ nodeType: TreeNodeType) -> TreeNodeEditable{
        switch aggregator{
        case .Mean: return TreeNodeAverage(name:n, date: d, includeInAggregation: aggregate, campName: camp, nodeType: nodeType)
        case .Sum: return TreeNodeSum(name:n, date: d, includeInAggregation: aggregate, campName: camp, nodeType: nodeType)
        }
    }
    
    
    
}
