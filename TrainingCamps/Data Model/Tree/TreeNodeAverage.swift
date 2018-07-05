//
//  TreeNodeAverage.swift
//  TrainingCamps
//
//  Created by Steven Lord on 24/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class TreeNodeAverage:NSObject, TreeNodeEditable{
    
    var nodeType: String = ""
    

    var rankTotalAscentMetres: Int = 0
    var rankTotalKM: Int = 0
    var rankTotalSeconds: Int = 0
    var rankSwimSeconds: Int = 0
    var rankSwimKM: Int = 0
    var rankBikeAscent: Int = 0
    var rankBikeKM: Int = 0
    var rankBikeSeconds: Int = 0
    var rankRunAscent: Int = 0
    var rankRunKM: Int = 0
    var rankRunSeconds: Int = 0
    
    
    var role: String? {return nil}
    var completed: Bool {return children.reduce(true, {$0 && $1.completed})}
    var includeInAggregation: Bool = true
    var childCount: Int { return children.count}
    @objc var camp: String?
    @objc var gender: String? {return nil}

    
    var children: [TreeNode] = []
    var treeNodeName: String? = ""
    var date: Date?
    
    var totalKM:            Double {
        return children.filter({$0.includeInAggregation}).reduce(0.0, {$0 + $1.totalKM}) / numberOfChildrenForAverage()
    }
    var swimKM:             Double {
        return children.filter({$0.includeInAggregation}).reduce(0.0, {$0 + $1.swimKM}) / numberOfChildrenForAverage()
    }
    var bikeKM:             Double {
        return children.filter({$0.includeInAggregation}).reduce(0.0, {$0 + $1.bikeKM}) / numberOfChildrenForAverage()
    }
    var runKM:              Double {
        return children.filter({$0.includeInAggregation}).reduce(0.0, {$0 + $1.runKM}) / numberOfChildrenForAverage()
    }
    var totalSeconds:       Double {
        return children.filter({$0.includeInAggregation}).reduce(0.0, {$0 + $1.totalSeconds}) / numberOfChildrenForAverage()
    }
    var swimSeconds:        Double {
        return children.filter({$0.includeInAggregation}).reduce(0.0, {$0 + $1.swimSeconds}) / numberOfChildrenForAverage()
    }
    var bikeSeconds:        Double {
        return children.filter({$0.includeInAggregation}).reduce(0.0, {$0 + $1.bikeSeconds}) / numberOfChildrenForAverage()
    }
    var runSeconds:         Double {
        return children.filter({$0.includeInAggregation}).reduce(0.0, {$0 + $1.runSeconds}) / numberOfChildrenForAverage()
    }
    var totalAscentMetres: Double {
        return children.filter({$0.includeInAggregation}).reduce(0.0, {$0 + $1.totalAscentMetres}) / numberOfChildrenForAverage()
    }
    var bikeAscentMetres: Double {
        return children.filter({$0.includeInAggregation}).reduce(0.0, {$0 + $1.bikeAscentMetres}) / numberOfChildrenForAverage()
    }
    var runAscentMetres: Double {
        return children.filter({$0.includeInAggregation}).reduce(0.0, {$0 + $1.runAscentMetres}) / numberOfChildrenForAverage()
    }
    var daysCount:          Double {
        return children.reduce(0.0, {$0 + $1.daysCount}) / numberOfChildrenForAverage()
    }
    var raceResultsCount:   Double {
        return children.reduce(0.0, {$0 + $1.raceResultsCount}) / numberOfChildrenForAverage()
    }

    
    
    func leavesShow(participantName show: Bool) {
        for c in children{
            c.leavesShow(participantName: show)
        }
    }
    
    func addChild(_ child: TreeNode){ children.append(child) }
    func addChildren(_ children: [TreeNode]) { self.children.append(contentsOf: children)}
    
    func set(name: String){
        treeNodeName = name
    }
    
    func numberOfChildrenForAverage() -> Double{
        return Double(children.count)
    }
    
    @objc dynamic var height: Int {
        var childHeights: [Int] = []
        for c in children{
            childHeights.append(c.height)
        }
        return 1 + childHeights.reduce(0, {max($0, $1)})
    }
    
    init(name: String, date d: Date?, includeInAggregation: Bool, campName: String?, nodeType: TreeNodeType){
        super.init()
        self.nodeType = nodeType.rawValue
        camp = campName
        set(name: name)
        date = d
        self.includeInAggregation = includeInAggregation
    }
    

    
    func rankChildren() {
        for c in children{
            c.rankChildren()
        }
        var rank = 1
        for i in children.sorted(by: {$0.totalAscentMetres > $1.totalAscentMetres}){
            i.rankTotalAscentMetres = rank
            rank += 1
        }
        rank = 1
        for i in children.sorted(by: {$0.totalKM > $1.totalKM}){
            i.rankTotalKM = rank
            rank += 1
        }
        rank = 1
        for i in children.sorted(by: {$0.totalSeconds > $1.totalSeconds}){
            i.rankTotalSeconds = rank
            rank += 1
        }
        rank = 1
        for i in children.sorted(by: {$0.swimKM > $1.swimKM}){
            i.rankSwimKM = rank
            rank += 1
        }
        rank = 1
        for i in children.sorted(by: {$0.swimSeconds > $1.swimSeconds}){
            i.rankSwimSeconds = rank
            rank += 1
        }
        rank = 1
        for i in children.sorted(by: {$0.bikeAscentMetres > $1.bikeAscentMetres}){
            i.rankBikeAscent = rank
            rank += 1
        }
        rank = 1
        for i in children.sorted(by: {$0.bikeKM > $1.bikeKM}){
            i.rankBikeKM = rank
            rank += 1
        }
        rank = 1
        for i in children.sorted(by: {$0.bikeSeconds > $1.bikeSeconds}){
            i.rankBikeSeconds = rank
            rank += 1
        }
        rank = 1
        for i in children.sorted(by: {$0.runAscentMetres > $1.runAscentMetres}){
            i.rankRunAscent = rank
            rank += 1
        }
        rank = 1
        for i in children.sorted(by: {$0.runKM > $1.runKM}){
            i.rankRunKM = rank
            rank += 1
        }
        rank = 1
        for i in children.sorted(by: {$0.runSeconds > $1.runSeconds}){
            i.rankRunSeconds = rank
            rank += 1
        }

        
        
    }
    
}
