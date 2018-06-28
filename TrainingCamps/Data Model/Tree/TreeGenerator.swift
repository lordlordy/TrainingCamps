//
//  TreeGenerator.swift
//  TrainingCamps
//
//  Created by Steven Lord on 25/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class TreeGenerator{
    
    enum TreeOrder: String{
        case standard               = "Camp -> Training -> Day -> Athlete"
        case campPersonTraining     = "Camp -> Athlete -> Training -> Day"
        case campTrainingPerson     = "Camp -> Training -> Athlete"
        case trainingAthleteCamp    = "Training -> AthleteCamp"
        static var All: [TreeOrder] = [standard, campPersonTraining, campTrainingPerson, trainingAthleteCamp]
    }
    
    private var filter: ParticipantFilter = ParticipantFilter.All
    
    func generateTree(forGroup cg: CampGroup, forCamps camps: [Camp]?, andOrder order: TreeOrder, nodesShow meanOrSum: Maths.Aggregator, participantFilter filter: ParticipantFilter) -> [TreeNode]{
        self.filter = filter
        var result: [TreeNode] = []
        switch order{
        case .standard:             result = generateStandardTree(cg, camps, meanOrSum)
        case .campPersonTraining:   result =  generateCampPersonTraining(cg, camps, meanOrSum)
        case .campTrainingPerson:   result =  generateCampTrainingPerson(cg, camps, meanOrSum)
        case .trainingAthleteCamp:  result =  generateTrainingAthleteCamp(cg, camps, meanOrSum)
        }
        for r in result{
            r.rankChildren()
        }
        return result
    }
    
    private func generateStandardTree(_ cg: CampGroup, _ c: [Camp]?, _ meanOrSum: Maths.Aggregator) -> [TreeNode]{
        let rootNode: TreeNodeEditable = newGenericTreeNode(name: cg.name ?? "Not Set", date: cg.earliestCampStart, meanOrSum, true, nil)
        var camps: [Camp] = cg.campsArray()
        var campNodes: [TreeNode] = []
        
        if c != nil{
            rootNode.set(name: "All")
            camps = c!
        }

        for camp in camps{
            let campStart: Date = camp.campStart ?? Date()
            let campNode: TreeNodeEditable = newGenericTreeNode(name: camp.campName ?? "Not Set", date: campStart, meanOrSum, true, camp.campName)
            campNodes.append(campNode)
            rootNode.addChild(campNode)
            let trainingNode: TreeNodeEditable = newGenericTreeNode(name: "Training", date: campStart, meanOrSum, true, camp.campName)
            campNode.addChild(trainingNode)
            for d in camp.campDaysArray(){
                let df: DateFormatter = DateFormatter()
                df.dateFormat = DateFormatString.DayOfWeekOnly.rawValue
                let dayNode: TreeNodeEditable = newGenericTreeNode(name: df.string(from: d.date!),date: d.date ?? Date(), meanOrSum, true, camp.campName)
                trainingNode.addChild(dayNode)
                for pd in filtered(participantDays: d.participantDaysArray()) {
                    dayNode.addChild( ParticipantDayTreeNode(pd))
                }
            }
            let racingNode: TreeNodeEditable = newGenericTreeNode( name: "Races", date: campStart, meanOrSum, false,camp.campName)
            campNode.addChild(racingNode)
            for race in camp.getRacesArray(){
                let raceNode: TreeNodeEditable = newGenericTreeNode(name: race.raceDefinition?.name ?? "Not Set", date: race.date ?? Date(), meanOrSum, true,camp.campName)
                racingNode.addChild(raceNode)
                for result in filtered(raceResults: race.raceResultsArray()) {
                    raceNode.addChild(RaceResultTreeNode(result))
                }
            }
        }
        rootNode.leavesShow(participantName: true)

        if campNodes.count == 1{
            return [campNodes[0]]
        }
        
        return [rootNode]

        
    }
    
    private func generateCampPersonTraining(_ cg: CampGroup, _ c: [Camp]?, _ meanOrSum: Maths.Aggregator) -> [TreeNode]{
        var camps: [Camp] = c ?? cg.campsArray()
        if camps.count == 0 { camps = cg.campsArray()}
        
        
        if camps.count > 1{
            let rootNode: TreeNodeEditable = newGenericTreeNode(name: "All", date: cg.earliestCampStart, meanOrSum, true, nil)
            for c in camps{
                let campDate: Date = c.campStart ?? Date()
                let campNode: TreeNodeEditable = newGenericTreeNode( name: c.campName ?? "Not Set", date: campDate, meanOrSum, true, c.campName)
                rootNode.addChild(campNode)
                for cp in filtered(campParticipants: c.campParticipantsArray()) {
                    let cpNode: TreeNodeEditable = newGenericTreeNode(name: cp.participant?.displayName ?? "Not set", date: campDate, meanOrSum, true, c.campName)
                    campNode.addChild(cpNode)
                    let trainingNode: TreeNodeEditable = newGenericTreeNode( name: "Training", date: campDate, meanOrSum, true,c.campName)
                    cpNode.addChild(trainingNode)
                    for d in filtered(participantDays: cp.getDays()) {
                        trainingNode.addChild(ParticipantDayTreeNode(d))
                    }
                    let racesNode: TreeNodeEditable = newGenericTreeNode(name: "Races", date: campDate, meanOrSum, false,c.campName)
                    cpNode.addChild(racesNode)
                    for r in filtered(raceResults: cp.getRaces()) {
                        racesNode.addChild(RaceResultTreeNode(r))
                    }
                }
            }
            rootNode.leavesShow(participantName: false)
            return [rootNode]
        }else if camps.count == 1{
            let campDate: Date = camps[0].campStart ?? Date()
            let campNode: TreeNodeEditable = newGenericTreeNode(name: camps[0].campName ?? "Not Set", date: campDate, meanOrSum, true, camps[0].campName)
            for cp in filtered(campParticipants: camps[0].campParticipantsArray()) {
                let cpNode: TreeNodeEditable = newGenericTreeNode(name: cp.participant?.displayName ?? "Not set", date: campDate, meanOrSum, true, camps[0].campName)
                campNode.addChild(cpNode)
                let trainingNode: TreeNodeEditable = newGenericTreeNode(name: "Training", date: campDate, meanOrSum, true,camps[0].campName)
                cpNode.addChild(trainingNode)
                for d in filtered(participantDays: cp.getDays()) {
                    trainingNode.addChild(ParticipantDayTreeNode(d))
                }
                let racesNode: TreeNodeEditable = newGenericTreeNode(name: "Races", date: campDate, meanOrSum, false, camps[0].campName)
                cpNode.addChild(racesNode)
                for r in filtered(raceResults: cp.getRaces()) {
                    racesNode.addChild(RaceResultTreeNode(r))
                }
            }
            campNode.leavesShow(participantName: false)
            return [campNode]
        }
        return []
    }
    
    private func generateCampTrainingPerson(_ cg: CampGroup, _ c: [Camp]?, _ meanOrSum: Maths.Aggregator) -> [TreeNode]{
        var camps: [Camp] = c ?? cg.campsArray()
        if camps.count == 0 { camps = cg.campsArray()}
    
        var rootName: String = "All"
        if camps.count == 1 { rootName = camps[0].campName ?? "All"}
        
        let rootNode = newGenericTreeNode(name: rootName, date: nil, meanOrSum, true, nil)
        let trainingNode = newGenericTreeNode(name: "Training", date: nil, meanOrSum, true, nil)
        let racingNode = newGenericTreeNode(name: "Races", date: nil, meanOrSum, false, nil)
        
        rootNode.addChild(trainingNode)
        rootNode.addChild(racingNode)
        
        var days: [ParticipantDayTreeNode] = []
        var resultDict: [String: TreeNodeEditable] = [:]

        for camp in camps{
            for cp in filtered(campParticipants: camp.campParticipantsArray()) {
                for d in filtered(participantDays: cp.getDays()) {
                    days.append(ParticipantDayTreeNode(d))
                }
            }
            for race in camp.getRacesArray(){
                if resultDict[race.name!] == nil{
                    let raceNode = newGenericTreeNode(name: race.name!, date: race.raceDefinition!.firstRunning, meanOrSum, true, nil)
                    racingNode.addChild(raceNode)
                    resultDict[race.name!] = raceNode
                }
                for r in filtered(raceResults: race.raceResultsArray()) {
                    resultDict[race.name!]!.addChild(RaceResultTreeNode(r))
                }
            }
        }
        trainingNode.addChildren(days)
        
        rootNode.leavesShow(participantName: true)
        
        return [rootNode]
    
    }
    
    private func generateTrainingAthleteCamp(_ cg: CampGroup, _ c: [Camp]?, _ meanOrSum: Maths.Aggregator) -> [TreeNode]{
        var camps: [Camp] = c ?? cg.campsArray()
        if camps.count == 0 { camps = cg.campsArray()}
        
        var rootName: String = "All"
        if camps.count == 1 { rootName = camps[0].campName ?? "All"}
        
        let rootNode = newGenericTreeNode(name: rootName, date: nil, meanOrSum, true, nil)
        let trainingNode = newGenericTreeNode(name: "Training", date: nil, meanOrSum, true, nil)
        let racingNode = newGenericTreeNode( name: "Races", date: nil, meanOrSum, false, nil)
        
        rootNode.addChild(trainingNode)
        rootNode.addChild(racingNode)
        
        var resultDict: [String: TreeNodeEditable] = [:]
        
        for camp in camps{
            for cp in filtered(campParticipants: camp.campParticipantsArray()) {
                let cpNode = newGenericTreeNode(name: (cp.participant?.displayName ?? "Not Set") + " - " + (camp.campName ?? "not set"), date: cp.camp?.campStart ?? Date(), meanOrSum, true, camp.campName)
                trainingNode.addChild(cpNode)
                for d in filtered(participantDays: cp.getDays()) {
                    cpNode.addChild(ParticipantDayTreeNode(d))
                }
            }
            for race in camp.getRacesArray(){
                if resultDict[race.name!] == nil{
                    let raceNode = newGenericTreeNode(name: race.name!, date: race.raceDefinition!.firstRunning, meanOrSum, true, camp.campName)
                    racingNode.addChild(raceNode)
                    resultDict[race.name!] = raceNode
                }
                for r in filtered(raceResults: race.raceResultsArray()) {
                    resultDict[race.name!]!.addChild(RaceResultTreeNode(r))
                }
            }
        }
        
        rootNode.leavesShow(participantName: false)
        
        return [rootNode]
        
    }
    
    private func filtered(participantDays days: [ParticipantDay]) -> [ParticipantDay]{
        switch filter{
        case .All: return days
        case .Athlete, .Coach: return days.filter({$0.campParticipant!.role! == filter.rawValue})
        case .Male, .Female: return days.filter({$0.campParticipant!.participant!.gender! == filter.rawValue})
        case .Completer: return days.filter({$0.campParticipant!.campComplete})
        }
    }
    
    private func filtered(campParticipants participants: [CampParticipant]) -> [CampParticipant]{
        switch filter{
        case .All: return participants
        case .Athlete, .Coach: return participants.filter({$0.role! == filter.rawValue})
        case .Male, .Female: return participants.filter({$0.participant!.gender! == filter.rawValue})
        case .Completer: return participants.filter({$0.campComplete})
        }
    }
    
    private func filtered(raceResults results: [RaceResult]) -> [RaceResult]{
        switch filter{
        case .All: return results
        case .Athlete, .Coach: return results.filter({$0.campParticipant!.role == filter.rawValue})
        case .Male, .Female: return results.filter({$0.campParticipant!.participant!.gender == filter.rawValue})
        case .Completer: return results.filter({$0.campParticipant!.campComplete})
        }
    }
    
    
    private func newGenericTreeNode(name n: String, date d: Date?,_ meanOrSum: Maths.Aggregator, _ aggregate: Bool, _ camp: String?) -> TreeNodeEditable{
        switch meanOrSum{
        case .Mean: return TreeNodeAverage(name:n, date: d, includeInAggregation: aggregate, campName: camp)
        case .Sum: return TreeNodeSum(name:n, date: d, includeInAggregation: aggregate, campName: camp)
        }
    }
    
}
