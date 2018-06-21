//
//  ParticipantRacesNode.swift
//  TrainingCamps
//
//  Created by Steven Lord on 14/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class ParticipantRacesNode: TreeNodeImplementation{
    
    override var completionCount: Int{
        return campComplete ? 1:0
    }
    
}
