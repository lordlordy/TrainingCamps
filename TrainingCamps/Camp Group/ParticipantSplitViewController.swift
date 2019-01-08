//
//  ParticipantSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 28/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class ParticipantSplitViewController: NSSplitViewController{
    
    
    func setParticipants(_ participants: [Participant]){
        for c in children{
            if let vc = c as? ParticipantViewControllerProtocol{
                if participants.count > 0{
                    vc.setParticipant(participants[0])
                }
            }
            if let tree = c as? TreeNodeViewController{
                tree.setGenerator(TreeGeneratorParticipant(participants))
            }
        }
    }
    
    
}
