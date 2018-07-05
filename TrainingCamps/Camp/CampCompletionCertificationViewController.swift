//
//  CampCompletionCertificationViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 03/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampCompletionCertificationViewController: NSViewController, CampParticipantViewControllerProtocol{
    
    @IBOutlet var certificateView: NSView!
    
    @objc dynamic var campParticipant: CampParticipant?
    @objc dynamic var campParticipantArray: [CampParticipant] = []
    @objc dynamic var trainingNodes: [TreeNode] = []
    
    
    @objc dynamic var logoURL: URL? {
        return Bundle.main.url(forResource: "et_final_Transparent", withExtension: "jpg")
    }
    
    @objc dynamic var footer: String = ""

    
    func setCampParticipant(_ campParticipant: CampParticipant) {
        self.campParticipant = campParticipant
        campParticipantArray = [campParticipant]
        setFooter()
        createTreeViews(campParticipant)
    }
    
    
    private func setFooter(){
        footer = ""
        if let camp = campParticipant?.camp{
            footer += camp.campName ?? "Not Set"
            let df = DateFormatter()
            df.dateFormat = "dd-MMM-yy"
            footer += " ( "
            footer += df.string(from: camp.campStart!)
            footer += " -> "
            footer += df.string(from: camp.campEnd!)
            footer += " )"
        }
    }
    
    private func createTreeViews(_ cp: CampParticipant){
        let rootNode = TreeNodeSum(name: cp.camp!.campName!, date: cp.camp!.campStart!, includeInAggregation: true, campName: cp.camp!.campName!, nodeType: TreeNodeType.Root)
        for day in cp.getDays().sorted(by: {$0.day!.date! < $1.day!.date!}){
            rootNode.addChild(ParticipantDayTreeNode(day))
        }
        rootNode.rankChildren()
        rootNode.leavesShow(participantName: false)
        trainingNodes = [rootNode]
    }
    
}
