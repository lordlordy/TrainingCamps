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
        case trainingCamp = "Athlete -> Training -> Camp"
        static var All: [TreeOrder] = [standard, trainingCamp]
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
            case .trainingCamp: result = generateTrainingCampTree()
            }
        }else{
            result = generateStandardTree()
        }
        
        for r in result{
            r.rankChildren()
        }
        
        return result
    }
    
    private func generateTrainingCampTree() -> [TreeNode]{
        let rootNode: TreeNodeEditable = newGenericTreeNode(name: "All", date: nil, true, nil, TreeNodeType.Root)
        let trainingNode: TreeNodeEditable = newGenericTreeNode(name: "Training", date: nil, true, nil, TreeNodeType.Training)
        let racingNode: TreeNodeEditable = newGenericTreeNode(name: "Racing", date: nil, false, nil, TreeNodeType.Racing)
        rootNode.addChild(trainingNode)
        rootNode.addChild(racingNode)
        
        for p in participants{
            let pNodeTraining: TreeNodeEditable = newGenericTreeNode(name: p.displayName, date: p.firstCampDate, true, nil, TreeNodeType.Participant)
            let pNodeRacing: TreeNodeEditable = newGenericTreeNode(name: p.displayName, date: p.firstCampDate, true, nil, TreeNodeType.Participant)
            trainingNode.addChild(pNodeTraining)
            racingNode.addChild(pNodeRacing)
            
            var raceDict: [String: TreeNodeEditable] = [:]
            for c in p.campParticipations?.allObjects as? [CampParticipant] ?? []{
                //training first
                let campNode: TreeNodeEditable = newGenericTreeNode(name: c.campName, date: c.camp?.campStart, true, c.campName, TreeNodeType.Camp)
                pNodeTraining.addChild(campNode)
                for d in c.getDays(){
                    campNode.addChild(ParticipantDayTreeNode(d))
                }
                
                //now racing
                for r in c.getRaces(){
                    if raceDict[r.race!.raceDefinition!.name!] == nil{
                        raceDict[r.race!.raceDefinition!.name!] = newGenericTreeNode(name: r.race!.raceDefinition!.name!, date: r.race!.date, true, c.campName, TreeNodeType.RaceResult)
                        pNodeRacing.addChild(raceDict[r.race!.raceDefinition!.name!]!)
                    }
                    raceDict[r.race!.raceDefinition!.name!]?.addChild(RaceResultTreeNode(r))
                }
            }
            
        }
        
        rootNode.rankChildren()
        rootNode.leavesShow(trainingLeafNameType: TrainingLeafNameType.DayOfWeek.rawValue, racingLeafNameType: RacingLeafNameType.CampName.rawValue)
        
        return [rootNode]
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
        rootNode.leavesShow(trainingLeafNameType: TrainingLeafNameType.DayOfWeek.rawValue, racingLeafNameType: RacingLeafNameType.RaceName.rawValue)
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
