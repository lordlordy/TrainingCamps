//
//  CampParticipantsRacesViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampParticipantsRacesViewController: NSViewController, CampParticipantViewControllerProtocol{
    
    @objc dynamic var campParticipant: CampParticipant?
    
    func setCampParticipant(_ campParticipant: CampParticipant) {
        self.campParticipant = campParticipant
    }
    
}
