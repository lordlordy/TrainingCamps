//
//  CampGroup+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 06/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension CampGroup{
    
    func participant(withUniqueName name: String) -> Participant?{
        let filteredArray = participantArray().filter({$0.uniqueName == name})
        if filteredArray.count > 0{
            return filteredArray[0]
        }
        return nil
    }
    
    private func participantArray() -> [Participant]{
        return participants?.allObjects as? [Participant] ?? []
    }
    
    private func raceDefinitionArray() -> [RaceDefinition]{
        return raceDefinitions?.allObjects as? [RaceDefinition] ?? []
    }
    
}
