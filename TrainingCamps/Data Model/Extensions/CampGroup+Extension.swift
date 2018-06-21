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

    func participant(withDisplayName name: String) -> Participant?{
        let filteredArray = participantArray().filter({$0.displayName == name})
        if filteredArray.count > 0{
            return filteredArray[0]
        }
        return nil
    }
    
    func raceDefinition(withName name: String) -> RaceDefinition?{
        let filteredArray = raceDefinitionArray().filter({$0.name == name})
        if filteredArray.count > 0{
            return filteredArray[0]
        }
        return nil
    }
    
    func location(forName name: String) -> Location?{
        let filteredArray = locationsArray().filter({$0.name == name})
        if filteredArray.count > 0{
            return filteredArray[0]
        }
        return nil
    }

    func campType(forName name: String) -> CampType?{
        let filteredArray = campTypesArray().filter({$0.name == name})
        if filteredArray.count > 0{
            return filteredArray[0]
        }
        return nil
    }
    
    func createNewLocation(forName name: String){
        if location(forName: name) == nil{
            let newLocation: Location = CoreDataStack.shared.newLocation()
            newLocation.name = name
            mutableSetValue(forKey: CampGroupProperty.locations.rawValue).add(newLocation)
        }
    }
    
    func createNewCampType(forName name: String){
        if campType(forName: name) == nil{
            let newCampType: CampType = CoreDataStack.shared.newCampType()
            newCampType.name = name
            mutableSetValue(forKey: CampGroupProperty.campTypes.rawValue).add(newCampType)
        }
    }
    
    func generateTree() -> [TreeNode]{
        let root: TreeNode = TreeNodeImplementation(name: "ALL", date: Date())
        for camp in campsArray(){
            root.addChild(camp.generateTreeByDay())
        }
        return [root]
    }
    
    func participantArray() -> [Participant]{
        return participants?.allObjects as? [Participant] ?? []
    }
    
    func locationsArray() -> [Location]{
        return locations?.allObjects as? [Location] ?? []
    }
    
    func campTypesArray() -> [CampType]{
        return campTypes?.allObjects as? [CampType] ?? []
    }
    
    func races(forLocation l: Location) -> [RaceDefinition]{
        return raceDefinitionArray().filter({$0.location!.name! == l.name})
    }
    
    private func raceDefinitionArray() -> [RaceDefinition]{
        return raceDefinitions?.allObjects as? [RaceDefinition] ?? []
    }
    

    
    private func campsArray() -> [Camp]{
        return camps?.allObjects as? [Camp] ?? []
    }
    
}
