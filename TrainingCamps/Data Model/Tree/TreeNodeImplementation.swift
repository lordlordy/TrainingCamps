//
//  TreeNodeImplementation.swift
//  TrainingCamps
//
//  Created by Steven Lord on 14/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class TreeNodeImplementation: NSObject, TreeNode{
    
    var children: [TreeNode] = []
    var leaves: [TreeNode]{
        return getLeaves()
    }
    
    func addChild(_ child: TreeNode) {
        children.append(child)
    }
    
    var name: String
    var date: Date
    
    var campComplete: Bool{return children.reduce(true, {$0 && $1.campComplete})}
    var completionStatus: String { return campComplete ? "Yes":"No"}
    var completionCount: Int {return children.reduce(0, {$0 + $1.completionCount})}
    
    var totalKM:        Double {return children.reduce(0.0, {$0 + $1.totalKM}) }
    var swimKM:         Double {return children.reduce(0.0, {$0 + $1.swimKM}) }
    var bikeKM:         Double {return children.reduce(0.0, {$0 + $1.bikeKM}) }
    var runKM:          Double {return children.reduce(0.0, {$0 + $1.runKM}) }
    var totalSeconds:   Double {return children.reduce(0.0, {$0 + $1.totalSeconds}) }
    var swimSeconds:    Double {return children.reduce(0.0, {$0 + $1.swimSeconds}) }
    var bikeSeconds:    Double {return children.reduce(0.0, {$0 + $1.bikeSeconds}) }
    var runSeconds:     Double {return children.reduce(0.0, {$0 + $1.runSeconds}) }
    
    var rank: Int = 0
    var swimRank: Int = 0
    var bikeRank: Int = 0
    var runRank: Int = 0
    
    @objc var childCount: Int { return children.count}
    @objc var dayCount: Int { return children.reduce(0, {$0 + $1.dayCount})}
    @objc var raceCount: Int { return children.reduce(0, {$0 + $1.raceCount})}
    
    init(name: String, date: Date){
        self.name = name
        self.date = date
    }
    
    private func getLeaves() -> [TreeNode]{
        var result: [TreeNode] = []
        if children.count == 0{
            result.append(self)
        }else{
            for c in children{
                result.append(contentsOf: c.leaves)
            }
        }
        return result
    }
    
    // this looks at leaves per participant and sees how many participants have completed all bits
    func countTrainingCompletions() -> Int{
        //lets make a dictionary of the leaves - coded from the name
        var dict: [String: Bool] = [:]
        
        for l in leaves{
            if let i = dict[l.name]{
                dict[l.name] = i && l.campComplete
            }else{
                dict[l.name] = l.campComplete
            }
        }
        
        var count: Int = 0
        
        for d in dict{
            if d.value { count += 1}
        }
        
        return count
    }
    
    func rankChildren(){
        //first rank on total time
        var sorted: [TreeNode] = children.sorted(by: {$0.totalSeconds > $1.totalSeconds})
        var rank: Int = 1
        for s in sorted{
            s.rank = rank
            rank += 1
        }
        
        //now swim seconds
        sorted = children.sorted(by: {$0.swimSeconds > $1.swimSeconds})
        rank = 1
        for s in sorted{
            s.swimRank = rank
            rank += 1
        }

        //now bike seconds
        sorted = children.sorted(by: {$0.bikeSeconds > $1.bikeSeconds})
        rank = 1
        for s in sorted{
            s.bikeRank = rank
            rank += 1
        }

        //now run seconds
        sorted = children.sorted(by: {$0.runSeconds > $1.runSeconds})
        rank = 1
        for s in sorted{
            s.runRank = rank
            rank += 1
        }

    
    }
    

    
}
