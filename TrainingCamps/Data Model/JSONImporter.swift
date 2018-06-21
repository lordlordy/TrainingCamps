//
//  JSONImporter.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//


import Cocoa

class JSONImporter{
    
    
    public func importCampGroup(fromURL url: URL){
        if let json = importJSON(fromURL: url) {
            let newCampGroup = CoreDataStack.shared.newCampGroup()
            
            //import participants and race definitions first
            if let p = json[CampGroupProperty.participants.rawValue] as? [[String:Any]]{
                addParticipants(fromJSON: p, toCampGroup: newCampGroup)
            }else{
                print("Participants not found and not imported")
            }
            
            if let rd = json[CampGroupProperty.raceDefinitions.rawValue] as? [[String:Any]]{
                addRaceDefinitions(fromJSON: rd, toCampGroup: newCampGroup)
            }else{
                print("Race definitions not found and not imported")
            }
            
            // finally camps
            if let camps = json[CampGroupProperty.camps.rawValue] as? [[String:Any]]{
                addCamps(fromJSON: camps, toCampGroup: newCampGroup)
            }else{
                print("Camps not found and not imported")
            }
            
            
//            for i in json{
//                print(i.key)
//                switch i.key{
//                case CampGroupProperty.camps.rawValue:
//                    if let camps = i.value as? [[String:Any]]{
//                        addCamps(fromJSON: camps, toCampGroup: newCampGroup)
//                    }
//                case CampGroupProperty.participants.rawValue:
//                    if let participants = i.value as? [[String:Any]]{
//                        addParticipants(fromJSON: participants, toCampGroup: newCampGroup)
//                    }
//                case CampGroupProperty.raceDefinitions.rawValue:
//                    if let raceDefinitions = i.value as? [[String:Any]]{
//                        addRaceDefinitions(fromJSON: raceDefinitions, toCampGroup: newCampGroup)
//                    }
//                default:
//                    print("Not imported \(i.key) in to CampGroup")
//                }
//            }
            
            newCampGroup.setValue("JSON IMPORT - \(Date().jsonString())", forKey: "name")
        }
    }
    
    private func importJSON(fromURL url: URL) -> [String:Any]?{
        
        print("Loading JSON from URL = \(url) ...")
        do{
            let data: Data = try Data.init(contentsOf: url)
            let jsonData  = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, .mutableContainers])
            let jsonDict = jsonData as? [String:Any]
            return jsonDict
        }catch{
            print("error initialising Training Diary for URL: " + url.absoluteString)
            return nil
        }
    }
    
    private func addParticipants(fromJSON participants: [[String:Any]], toCampGroup cg: CampGroup){
        for p in participants{
            let newParticipant: Participant = CoreDataStack.shared.newParticipant()
            cg.mutableSetValue(forKey: CampGroupProperty.participants.rawValue).add(newParticipant)
            
            for i in p{
                newParticipant.setValue(i.value, forKey: i.key)
            }
        }
    }
    
    private func addRaceDefinitions(fromJSON raceDefinitions: [[String:Any]], toCampGroup cg: CampGroup){
        for r in raceDefinitions{
            let newRaceDefinition: RaceDefinition = CoreDataStack.shared.newRaceDefinition()
            cg.mutableSetValue(forKey: CampGroupProperty.raceDefinitions.rawValue).add(newRaceDefinition)
            
            for i in r{
                if i.key == RaceDefinitionProperty.locationString.rawValue{
                    if let l = i.value as? String{
                        if cg.location(forName: l) == nil{
                            //set up location
                            cg.createNewLocation(forName: l)
                        }
                    }
                }
                newRaceDefinition.setValue(i.value, forKey: i.key)
            }
        }
    }
    
    private func addCamps(fromJSON camps: [[String:Any]], toCampGroup cg: CampGroup){
        for camp in camps{
            let newCamp: Camp = CoreDataStack.shared.newCamp()
            cg.mutableSetValue(forKey: CampGroupProperty.camps.rawValue).add(newCamp)
            
            //add camp participant first as these objects need to exist when everything else is added
            if let campParticipants = camp[CampProperty.campParticipants.rawValue] as? [[String:Any]]{
                addCampParticipants(forJSON: campParticipants, toCamp: newCamp)
            }
            
            
            for i in camp{
                switch i.key{
                case CampProperty.campStart.rawValue, CampProperty.campEnd.rawValue:
                    //date
                    if let d = Date.dateFromJSONString(i.value as! String){
                        newCamp.setValue(d, forKey: i.key)
                    }
                case CampProperty.campName.rawValue, CampProperty.campShortName.rawValue:
                    newCamp.setValue(i.value, forKey: i.key)
                case CampProperty.days.rawValue:
                    if let days = i.value as? [[String:Any]]{
                        addDays(forJSON: days, toCamp: newCamp)
                    }
                case CampProperty.races.rawValue:
                    if let races = i.value as? [[String:Any]]{
                        addRaces(forJSON: races, toCamp: newCamp)
                    }
                case CampProperty.campParticipants.rawValue:
                    print("Camp Participants added first")
                case CampProperty.campLocation.rawValue:
                    if let location = cg.location(forName: i.value as! String){
                        newCamp.location = location
                    }else{
                        cg.createNewLocation(forName: i.value as! String)
                        newCamp.location = cg.location(forName: i.value as! String)
                    }
                case CampProperty.campType.rawValue:
                        if let campType = cg.campType(forName: i.value as! String){
                            newCamp.type = campType
                        }else{
                            cg.createNewCampType(forName: i.value as! String)
                            newCamp.type = cg.campType(forName: i.value as! String)
                    }
                default:
                    print("Not imported \(i.key) in to Camp")
                }
            }
        }
    }
    
    private func addCampParticipants(forJSON campParticipants: [[String:Any]], toCamp camp: Camp){
        for participant in campParticipants{
            let newCampParticipant: CampParticipant = CoreDataStack.shared.newCampParticipant()
            camp.mutableSetValue(forKey: CampProperty.campParticipants.rawValue).add(newCampParticipant)
            for i in participant{
                switch i.key{
                case "uniqueName": // move to enum
                    if let p = camp.campGroup?.participant(withUniqueName: i.value as? String ?? ""){
                        newCampParticipant.participant = p
                    }
                default:
                    newCampParticipant.setValue(i.value, forKey: i.key)
                }
                
            }
        }
        
        
    }

    
    private func addDays(forJSON days: [[String:Any]], toCamp camp: Camp){
        for day in days{
            let newDay: Day = CoreDataStack.shared.newDay()
            camp.mutableSetValue(forKey: CampProperty.days.rawValue).add(newDay)
            
            for i in day{
                switch i.key{
                    case DayProperty.completionBikeKM.rawValue, DayProperty.completionBikeKMWithWildcard.rawValue, DayProperty.earnWildcardBikeKM.rawValue, DayProperty.completionRunSeconds.rawValue, DayProperty.completionRunSecondsWithWildcard.rawValue, DayProperty.earnWildcardRunSeconds.rawValue,
                         DayProperty.completionSwimSeconds.rawValue, DayProperty.completionSwimSecondsWithWildcard.rawValue, DayProperty.earnWildcardSwimSeconds.rawValue:
                    newDay.setValue(i.value, forKey: i.key)
                case DayProperty.date.rawValue:
                    if let d = Date.dateFromJSONString(i.value as! String){
                        newDay.setValue(d, forKey: i.key)
                    }
                case DayProperty.participantDays.rawValue:
                    if let participantDays = i.value as? [[String:Any]]{
                        addParticipantDays(forJSON: participantDays, toDay: newDay)
                    }
                default:
                    print("Not imported \(i.key) in to Day")
                }
            }
            
            
        }
    }

    private func addParticipantDays(forJSON participantDays: [[String:Any]], toDay day: Day){
        for pday in participantDays{
            let newPDay: ParticipantDay = CoreDataStack.shared.newParticipantDay()
            day.mutableSetValue(forKey: DayProperty.participantDays.rawValue).add(newPDay)
            
            for i in pday{
                switch i.key{
                case ParticipantDayProperty.bikeAscentMetres.rawValue, ParticipantDayProperty.bikeKM.rawValue,  ParticipantDayProperty.bikeSeconds.rawValue, ParticipantDayProperty.bikeWildcardUsed.rawValue, ParticipantDayProperty.brick.rawValue, ParticipantDayProperty.runAscentMetres.rawValue, ParticipantDayProperty.runKM.rawValue, ParticipantDayProperty.runSeconds.rawValue, ParticipantDayProperty.runWildcardUsed.rawValue, ParticipantDayProperty.swimKM.rawValue, ParticipantDayProperty.swimSeconds.rawValue, ParticipantDayProperty.swimWildcardUsed.rawValue:
                    newPDay.setValue(i.value, forKey: i.key)
                case ParticipantDayProperty.participant.rawValue:
                    newPDay.campParticipant = day.camp?.campParticipant(forUniqueName: i.value as! String)
                default:
                    print("Not imported \(i.key) in to ParticipantDay")
                }
            }
        }
        
    }
    
    private func addRaces(forJSON races: [[String:Any]], toCamp camp: Camp){
        for race in races{
            let newRace: Race = CoreDataStack.shared.newRace()
            camp.mutableSetValue(forKey: CampProperty.races.rawValue).add(newRace)
            
            for i in race{
                switch i.key{
//                case RaceProperty.includesBike.rawValue, RaceProperty.includesRun.rawValue, RaceProperty.includesSwim.rawValue, RaceProperty.isForCampPoints.rawValue, RaceProperty.isGuessYourTime.rawValue, RaceProperty.isHandicap.rawValue, RaceProperty.pointsBasedOn.rawValue, RaceProperty.pointsForWinOverride.rawValue, RaceProperty.pointsIncrementOverride.rawValue, RaceProperty.pointsRaceNumber.rawValue:
                case RaceProperty.date.rawValue:
                    if let d = Date.dateFromJSONString(i.value as! String){
                        newRace.setValue(d, forKey: i.key)
                    }
                case RaceProperty.results.rawValue:
                    if let results = i.value as? [[String:Any]]{
                        addResults(forJSON: results, toRace: newRace)
                    }
                default:
                    newRace.setValue(i.value, forKey: i.key)
                }
            }
            
            
        }
    }
    
    private func addResults(forJSON results: [[String:Any]], toRace race: Race){
        for result in results{
            let newResult: RaceResult = CoreDataStack.shared.newRaceResult()
            race.mutableSetValue(forKey: RaceProperty.results.rawValue).add(newResult)
            
            for i in result{
                if i.key == RaceResultProperty.participant.rawValue{
                    newResult.campParticipant = race.camp?.campParticipant(forUniqueName: i.value as! String)
                }else{
                    newResult.setValue(i.value, forKey: i.key )
                }
            }
        }
        
    }
    
}
