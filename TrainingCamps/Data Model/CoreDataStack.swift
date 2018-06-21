//
//  CoreDataStack.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation
import CoreData

/*
 This class is meant to be purely for mediating with the Core Data Stack. There is some
 additional functionality in here that should be extracted in to another class mainly
 around creation of Base Data
 */
class CoreDataStack{
    
    static let shared = CoreDataStack()
    
    // MARK: - Core Data stack
    
    lazy var trainingCampsPC: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TrainingCamps")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            let type = storeDescription.type
            let url = storeDescription.url
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    func save(){
        do {
            try trainingCampsPC.viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func newCampGroup() -> CampGroup{
        let mo: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: ENTITY.CampGroup.rawValue, into: trainingCampsPC.viewContext)
        
        return mo as! CampGroup
    }
    
    func newCamp() -> Camp{
        let camp: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: ENTITY.Camp.rawValue, into: trainingCampsPC.viewContext)
        return camp as! Camp
    }
    
    func newDay() -> Day{
        let day: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: ENTITY.Day.rawValue, into: trainingCampsPC.viewContext)
        return day as! Day
    }
    
    func newParticipantDay() -> ParticipantDay{
        let participantDay: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: ENTITY.ParticipantDay.rawValue, into: trainingCampsPC.viewContext)
        return participantDay as! ParticipantDay
    }
    
    func newRace() -> Race{
        let race: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: ENTITY.Race.rawValue, into: trainingCampsPC.viewContext)
        return race as! Race
    }
    
    func newRaceResult() -> RaceResult{
        let result: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: ENTITY.RaceResult.rawValue, into: trainingCampsPC.viewContext)
        return result as! RaceResult
    }
    
    func newParticipant() -> Participant{
        let participant: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: ENTITY.Participant.rawValue, into: trainingCampsPC.viewContext)
        return participant as! Participant
    }
    
    func newRaceDefinition() -> RaceDefinition{
        let raceDefinition: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: ENTITY.RaceDefinition.rawValue, into: trainingCampsPC.viewContext)
        return raceDefinition as! RaceDefinition
    }
    
    func newCampParticipant() -> CampParticipant{
        let campParticipant: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: ENTITY.CampParticipant.rawValue, into: trainingCampsPC.viewContext)
        return campParticipant as! CampParticipant
    }
    
    func newLocation() -> Location{
        let location: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: ENTITY.Location.rawValue, into: trainingCampsPC.viewContext)
        return location as! Location
    }
    
    func newCampType() -> CampType{
        let campType: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: ENTITY.CampType.rawValue, into: trainingCampsPC.viewContext)
        return campType as! CampType
    }
    
}

