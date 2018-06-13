//
//  ParticipantDay+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 13/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension ParticipantDay{
    
    @objc dynamic var totalSeconds: Double{
        return swimSeconds + bikeSeconds + runSeconds   
    }
    
}
