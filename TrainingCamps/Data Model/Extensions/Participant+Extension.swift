//
//  Participant+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 06/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension Participant{
    
    @objc dynamic var campsAttended: Int{return campParticipations?.count ?? 0}
    @objc dynamic var noCampsAttended: Bool { return campsAttended == 0}
    
    
    @objc dynamic var displayName: String{
        var result: String = firstName ?? ""
        result += " " + (surname ?? "")
        return result
    }
    
    @objc dynamic var surnameFirstName: String{
        var result: String = surname ?? ""
        result += firstName ?? ""
        return result
    }
    
    func generateTree() -> TreeNode{
        
        let rootNode = TreeNodeImplementation(name: displayName, date: Date())
        
        for camp in campParticipationsArray().sorted(by: {$0.camp!.campStart! < $1.camp!.campStart!}){
            rootNode.addChild(camp.generateTree())
        }
        rootNode.rankChildren()
        return rootNode
    }
    
    private func campParticipationsArray() -> [CampParticipant]{
        return campParticipations?.allObjects as? [CampParticipant] ?? []
    }
    

}
