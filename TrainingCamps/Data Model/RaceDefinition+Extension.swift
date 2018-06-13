//
//  RaceDefinition+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 13/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension RaceDefinition{
    
    @objc dynamic var raceCount: Int{
        return races?.count ?? 0
    }
    
    
}
