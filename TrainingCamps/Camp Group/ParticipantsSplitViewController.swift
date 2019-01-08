//
//  ParticipantsSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 06/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class ParticipantsSplitViewController: CampGroupSplitViewController{
    
    @IBOutlet var participantsAC: NSArrayController!
    
    @IBOutlet var participantsCampsAC: NSArrayController!
    
//    private var flattenCamp: Bool = false
    
    func filter(forName name: String){
        if let pac = participantsAC{
            if name == ""{
                pac.filterPredicate = nil
            }else{
                pac.filterPredicate = NSPredicate.init(format: "uniqueName CONTAINS %@", argumentArray: [name])
            }
        }
    }
    
    func setParticipants(_ participants: [Participant]){
        for c in children{
            if let vc = c as? ParticipantSplitViewController{
                vc.setParticipants(participants)
            }
        }
    }
    
//    func toggleTree(){
//        flattenCamp = !flattenCamp
//        createTree()
//    }
    
//    func createTree(){
//        if flattenCamp{
//            setFlattenedTreeNodes()
//        }else{
//            setTreeNodes()
//        }
//    }
    
//    private func setFlattenedTreeNodes(){
//        if let tvc = getTreeController(){
//            let selection = getSelectedParticipants()
////            if selection.count == 0 {
////                return
////            }else if selection.count == 1{
////                let tree = selection[0].generateTree()
////                tvc.treeNodes = [tree]
////            }else{
////                let root = TreeNodeImplementation(name: "ALL", date: Date())
////                var camps: [CampParticipant] = []
////                for s in selection{
////                    camps.append(contentsOf: s.campParticipations?.allObjects as? [CampParticipant] ?? [])
////                }
////                for c in camps{
////                    let node = c.generateTree()
////                    node.name = c.participant?.uniqueName ?? "NAME NOT SET"
////                    node.name += "-"
////                    node.name += c.camp?.campName ?? "Camp not set"
////                    root.addChild(node)
////                }
////                root.rankChildren()
////                root.children = root.children.sorted(by: {$0.rank < $1.rank})
////                tvc.treeNodes = [root]
////            }
//        }
//    }
    
//    private func setTreeNodes(){
//        if let tvc = getTreeController(){
////            let selection = getSelectedParticipants()
////            if selection.count == 0 {
////                return
////            }else if selection.count == 1{
////                let tree = selection[0].generateTree()
////                tvc.treeNodes = [tree]
////            }else{
////                let root = TreeNodeImplementation(name: "ALL", date: Date())
////                for s in selection.sorted(by: {$0.uniqueName ?? "zzz" < $1.uniqueName ?? "zzz"}){
////                    let tree = s.generateTree()
////                    if tree.totalKM > 0{
////                        root.addChild(s.generateTree())
////                    }
////                }
////                root.rankChildren()
////                root.children = root.children.sorted(by: {$0.rank < $1.rank})
////                tvc.treeNodes = [root]
////            }
//        }
//    }

    
    private func getTreeController() -> TreeNodeViewController?{
        for c in children{
            if let t = c as? TreeNodeViewController{
                return t
            }
        }
        return nil
    }
    
    private func getSelectedParticipants() -> [Participant]{
        if let selection = participantsAC.selectedObjects as? [Participant]{
            return selection
        }
        return []
    }
}
