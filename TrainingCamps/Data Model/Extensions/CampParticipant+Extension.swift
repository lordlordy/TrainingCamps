//
//  CampParticipant+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 14/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension CampParticipant{
    
    @objc dynamic var trainingComplete: Bool{ return getDays().reduce(true, {$0 && $1.dayComplete})}
    @objc dynamic var racesComplete: Bool { return getRaces().reduce(true, {$0 && $1.campComplete}) && getRaces().count == camp?.races?.count ?? 0}
    @objc dynamic var campComplete: Bool{ return trainingComplete && racesComplete}
    
    @objc dynamic var campPoints: Int{ return Int(getRaces().reduce(0, {$0 + $1.campPoints}) + bonusPoints)}
    
    @objc dynamic var totalKM: Double { return getDays().reduce(0.0, {$0 + $1.totalKM})}
    @objc dynamic var totalSeconds: Double { return getDays().reduce(0.0, {$0 + $1.totalSeconds})}
    @objc dynamic var totalAscentMetres: Double { return bikeAscentMetres + runAscentMetres}
    @objc dynamic var swimKM: Double { return getDays().reduce(0.0, {$0 + $1.swimKM})}
    @objc dynamic var swimSeconds: Double { return getDays().reduce(0.0, {$0 + $1.swimSeconds})}
    @objc dynamic var bikeKM: Double { return getDays().reduce(0.0, {$0 + $1.bikeKM})}
    @objc dynamic var bikeSeconds: Double { return getDays().reduce(0.0, {$0 + $1.bikeSeconds})}
    @objc dynamic var bikeAscentMetres: Double { return getDays().reduce(0.0, {$0 + $1.bikeAscentMetres})}
    @objc dynamic var runKM: Double { return getDays().reduce(0.0, {$0 + $1.runKM})}
    @objc dynamic var runSeconds: Double { return getDays().reduce(0.0, {$0 + $1.runSeconds})}
    @objc dynamic var runAscentMetres: Double { return getDays().reduce(0.0, {$0 + $1.runAscentMetres})}
    @objc dynamic var bricks: Int { return getDays().reduce(0, {$0 + ($1.brick ? 1:0)})}

    @objc dynamic var totalCompetitionSeconds: Double { return getPointsRaces().reduce(0.0, {$0 + $1.totalSeconds})}
    
    @objc dynamic var numberOfDays: Int { return days?.count ?? 0 }
    @objc dynamic var numberOfRaces: Int { return raceResults?.count ?? 0 }
    @objc dynamic var noTraining: Bool { return numberOfRaces == 0 && numberOfDays == 0}
    
    @objc dynamic var campParticipantNameString: String{
        get { return participant?.displayName ?? "NOT SET"}
        set{
            if let cg = camp?.campGroup{
                if let p: Participant = cg.participant(withDisplayName: newValue){
                    participant = p
                }
            }
        }
    }
    
    @objc dynamic var completionStatus: String{
        if campComplete{
            return "Camp Complete"
        }else if trainingComplete{
            return "Training Complete"
        }else if racesComplete{
            return "Races Complete"
        }else{
            return "-"
        }
    }
    
    @objc dynamic var completeStatusSortKey: Int{
        if campComplete{
            return 1
        }else if trainingComplete{
            return 2
        }else if racesComplete{
            return 3
        }else{
            return 4
        }
    }
    
    func generateTree() -> TreeNode{
        
        //TRAINING
        let trainingNode = ParticipantTrainingNode(name: "Training", date: camp!.campStart!)
        
        for d in getDays().sorted(by: {$0.day!.date! < $1.day!.date!}){
            let dayNode = ParticipantDayNode(day: d)
            trainingNode.addChild(dayNode)
        }
        
        //RACE RESULT
        let racesNode = ParticipantRacesNode(name: "Races", date: Date())
        
        for r in getRaces().sorted(by: {$0.race!.date! < $1.race!.date!}){
            let resultNode = ParticipantRaceResultNode(raceResult: r)
            racesNode.addChild(resultNode)
        }
        
        
        
        let participantCampNode = ParticipantCampNode(name: camp!.campName!, date: camp!.campStart!, training: trainingNode, races: racesNode)
        
        participantCampNode.rankChildren()
        racesNode.rankChildren()
        trainingNode.rankChildren()
        
        return participantCampNode

    }
    
    private func getDays() -> [ParticipantDay]{
        return days?.allObjects as? [ParticipantDay] ?? []
    }
    
    private func getRaces() -> [RaceResult]{
        return raceResults?.allObjects as? [RaceResult] ?? []
    }
    
    private func getPointsRaces() -> [RaceResult]{
        return getRaces().filter({$0.includeInCampPoints})
    }
}
