//
//  CampGroup+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 06/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension CampGroup: TrainingValuesProtocol{
    
    private var rankUnits: [(activity: Activity, unit: Unit)]{
        var result: [(activity: Activity, unit: Unit)] = []
        result.append((Activity.total, unit: Unit.Seconds))
        result.append((Activity.total, unit: Unit.KM))
        result.append((Activity.total, unit: Unit.Ascent))
        result.append((Activity.swim, unit: Unit.Seconds))
        result.append((Activity.swim, unit: Unit.KM))
        result.append((Activity.bike, unit: Unit.Seconds))
        result.append((Activity.bike, unit: Unit.KM))
        result.append((Activity.bike, unit: Unit.Ascent))
        result.append((Activity.run, unit: Unit.Seconds))
        result.append((Activity.run, unit: Unit.KM))
        result.append((Activity.run, unit: Unit.Ascent))
        return result
    }
    
    @objc dynamic var totalSeconds: Double{ return valueFor(.total, .Seconds)}
    
    func rank(){
        let ranker: Ranker = Ranker()
        let days: [Rankable] = participantDaysArray()
        let participantsCamps: [Rankable] =  campParticipantsArray()
        
        ranker.rank(days, forRankUnits: rankUnits, isAscending: false)
        ranker.rank(participantsCamps, forRankUnits: rankUnits, isAscending: false)
        
    }
    
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
    
    func campsArray() -> [Camp]{ return camps?.allObjects as? [Camp] ?? []}
  
    func participantArray() -> [Participant]{ return participants?.allObjects as? [Participant] ?? []}
    
    func campParticipantsArray() -> [CampParticipant]{
        var result: [CampParticipant] = []
        for c in campsArray(){
            result.append(contentsOf: c.campParticipantsArray())
        }
        return result
    }
    
    func locationsArray() -> [Location]{ return locations?.allObjects as? [Location] ?? [] }
    
    func campTypesArray() -> [CampType]{ return campTypes?.allObjects as? [CampType] ?? [] }
    
    func participantDaysArray() -> [ParticipantDay]{
        var result: [ParticipantDay] = []
        for camp in campsArray(){
            for cp in camp.campParticipantsArray(){
                result.append(contentsOf: cp.getDays())
            }
        }
        return result
    }
    
    
    func races(forLocation l: Location) -> [RaceDefinition]{
        return raceDefinitionArray().filter({$0.location!.name! == l.name})
    }
    
    func valueFor(_ activity: Activity, _ unit: Unit) -> Double{
        return valueFor(activity.rawValue, unit.rawValue)
    }
    
    func valueFor(_ activity: String, _ unit: String) -> Double{
        return campsArray().reduce(0.0, {$0 + $1.valueFor(activity,unit)})
    }
    
    
    
    private func raceDefinitionArray() -> [RaceDefinition]{
        return raceDefinitions?.allObjects as? [RaceDefinition] ?? []
    }
    

    
}
