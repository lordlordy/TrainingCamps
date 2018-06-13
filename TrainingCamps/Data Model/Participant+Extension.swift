//
//  Participant+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 06/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension Participant{
    
    @objc dynamic var campsAttended: Int{
        return campParticipations?.count ?? 0
    }
    
}
