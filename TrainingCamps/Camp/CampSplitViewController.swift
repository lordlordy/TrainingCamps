//
//  CampSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampSplitViewController: NSSplitViewController, CampViewControllerProtocol, CampGroupViewControllerProtocol, TreeToggler{
    
    @objc dynamic var camp: Camp?
    @objc dynamic var campGroup: CampGroup?
    
//    private var byDay: Bool = true
//    private var camps: [Camp] = []
    
    func setCamp(_ camp: Camp) {
        self.camp = camp
        for c in childViewControllers{
            if let cvcp = c as? CampViewControllerProtocol{
                cvcp.setCamp(camp)
            }
        }
        if let w = view.window{
            w.title = camp.campName ?? "Unkown Camp"
        }
    }
    
    func setCampGroup(_ campGroup: CampGroup) {
        self.campGroup = campGroup
        for child in childViewControllers{
            if let c = child as? CampGroupViewControllerProtocol{
                c.setCampGroup(campGroup)
            }
        }
    }
    
    func toggleTree() {
//        byDay = !byDay
//        updateTreeNodes()
    }
    
    func setTreeNodes(forCamps camps: [Camp]?){
//        self.camps = camps.sorted(by: {$0.campStart! < $1.campStart!})
//        updateTreeNodes()
        if let tree = getTreeView(){
            tree.setCamps(camps)
        }
    }
    
    private func updateTreeNodes(){
//        if byDay{
//            setTreeNodesByDay()
//        }else{
//            setTreeNodesByParticipant()
//        }
    }
    
    private func setTreeNodesByDay(){
//        if let tv = getTreeView(){
//            if camps.count == 1{
//                tv.treeNodes = [camps[0].generateTreeByDay()]
//            }else if camps.count > 1{
//                let root = TreeNodeImplementation(name: "All", date: Date())
//                for camp in camps{
//                    root.addChild(camp.generateTreeByDay())
//                }
//                root.rankChildren()
//                tv.treeNodes = [root]
//            }
//        }
    }

    private func setTreeNodesByParticipant(){
//        if let tv = getTreeView(){
//            if camps.count == 1{
//                tv.treeNodes = [camps[0].generateTreeByParticipant()]
//            }else if camps.count > 1{
//                let root = TreeNodeImplementation(name: "All", date: Date())
//                for camp in camps{
//                    root.addChild(camp.generateTreeByParticipant())
//                }
//                root.rankChildren()
//                tv.treeNodes = [root]
//            }
//        }
    }
    
    private func getTreeView() -> TreeNodeViewController?{
        for child in childViewControllers{
            if let tv = child as? TreeNodeViewController{
                return tv
            }
            for grandchild in child.childViewControllers{
                if let tv = grandchild as? TreeNodeViewController{
                    return tv
                }
            }
        }
        return nil
    }
    
    
}
