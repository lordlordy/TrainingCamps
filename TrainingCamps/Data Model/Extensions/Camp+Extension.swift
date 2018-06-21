//
//  Camp+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 13/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension Camp{
    
    @objc dynamic var campLocation: String{ return location?.name ?? "CAMP LOCATION NOT SET" }
    @objc dynamic var campType: String{ return type?.name ?? "CAMP TYPE NOT SET" }
    
    @objc dynamic var completionCount: Int{
        var count: Int = 0
        for p in campParticipantsArray(){
            if p.campComplete { count += 1}
        }
        return count
    }
    
    @objc dynamic var participantCount: Int { return campParticipants?.count ?? 0}
    
    @objc var totalKM: Double { return swimKM + bikeKM + runKM }
    @objc var swimKM: Double { return campDaysArray().reduce(0.0, {$0 + $1.swimKM})}
    @objc var bikeKM: Double { return campDaysArray().reduce(0.0, {$0 + $1.bikeKM})}
    @objc var runKM: Double { return campDaysArray().reduce(0.0, {$0 + $1.runKM})}
    
    @objc var  bricks: Int {return campDaysArray().reduce(0, {$0 + $1.bricks})}
    
    @objc var totalAscentMetres: Double { return  bikeAscentMetres + runAscentMetres }
    @objc var bikeAscentMetres: Double { return campDaysArray().reduce(0.0, {$0 + $1.bikeAscentMetres})}
    @objc var runAscentMetres: Double { return campDaysArray().reduce(0.0, {$0 + $1.runAscentMetres})}
    
    @objc var totalSeconds: Double { return swimSeconds + bikeSeconds + runSeconds}
    @objc var swimSeconds: Double { return campDaysArray().reduce(0.0, {$0 + $1.swimSeconds})}
    @objc var bikeSeconds: Double { return campDaysArray().reduce(0.0, {$0 + $1.bikeSeconds})}
    @objc var runSeconds: Double { return campDaysArray().reduce(0.0, {$0 + $1.runSeconds})}
    
    @objc var campNameNotSet: Bool { return campName == nil || campName == ""}
    
    @objc var campDatesDescription: String{
        let df = DateFormatter()
        df.dateFormat =  DateFormatString.ValidCampDate.rawValue
        var str: String = "Dates Not Set"
        if let start = campStart{
            if let end = campEnd{
                str = df.string(from: start)
                str += " to "
                str += df.string(from: end)
            }
        }
        return str
    }
    
    @objc dynamic var locationString: String {
        get{
            return location?.name ?? "NOT SET"
        }
        set{
            if let cg = campGroup{
                location = cg.location(forName: newValue)
            }
        }
    }
    
    @objc dynamic var campTypeString: String {
        get{
            return type?.name ?? "NOT SET"
        }
        set{
            if let cg = campGroup{
                type = cg.campType(forName: newValue)
            }
        }
    }
    
    func campParticipantUniqueNames() -> [String]{
        return campParticipantsArray().map({$0.participant?.uniqueName ?? "NOT SET"})
    }

    func campParticipantDisplayNames() -> [String]{
        return campParticipantsArray().map({$0.participant?.displayName ?? "NOT SET"})
    }
    
    func validRaceDefinitions() -> [RaceDefinition]{
        if let cg = campGroup{
            if let l = location{
                return cg.races(forLocation: l)
            }
        }
        return []
    }
    
    func campParticipant(forUniqueName name:String) -> CampParticipant?{
        let filtered = campParticipantsArray().filter({$0.participant?.uniqueName == name})
        if filtered.count > 0{
            return filtered[0]
        }
        return nil
    }

    func campParticipant(forDisplayName name:String) -> CampParticipant?{
        let filtered = campParticipantsArray().filter({$0.participant?.displayName == name})
        if filtered.count > 0{
            return filtered[0]
        }
        return nil
    }
    
    func isOnCamp(uniqueName name: String) -> Bool{ return campParticipantUniqueNames().contains(name)}
    func isOnCamp(displayName name: String) -> Bool{ return campParticipantDisplayNames().contains(name)}

    func campDay(forDate d: Date ) -> Day?{
        if let start = campStart{
            if let end = campEnd{
                if Calendar.current.compare(d, to: start, toGranularity: .day) == ComparisonResult.orderedAscending{
                    return nil //before camp starts
                }
                if Calendar.current.compare(d, to: end, toGranularity: .day) == ComparisonResult.orderedDescending{
                    return nil //after camp ends
                }
                //a valid day has been requested ... if it doesn't exist then we must add it
                let days: [Day] = campDaysArray().filter({Calendar.current.compare(d, to: $0.date!, toGranularity: .day) == ComparisonResult.orderedSame})
                if days.count == 1 {
                    return days[0]
                }else{
                    //create a day with this date.
                    let newDay: Day = CoreDataStack.shared.newDay()
                    newDay.date = d
                    mutableSetValue(forKey: CampProperty.days.rawValue).add(newDay)
                }
            }
        }
        
        return nil
    }
    
    func validDates() -> [Date]{
        var result: [Date] = []
        if let start: Date = campStart{
            if let end: Date = campEnd{
                
                var d: Date = start
                result.append(start)
                
                while Calendar.current.compare(d, to: end, toGranularity: Calendar.Component.day) == ComparisonResult.orderedAscending{
                    d = d.addingTimeInterval(TimeInterval(60 * 60 * 24 )) //adding a days worth of seconds
                    result.append(d)
                }
            }
        }

        return result
        
    }
    
    func generateTreeByDay() -> TreeNode{

            let trainingNode = CampTrainingNode(name: "Training", date: campStart!)
            let racesNode = CampRacingNode(name: "Races", date: campStart!)
            
            let campDays: [Day] = days?.allObjects as? [Day] ?? []
            for d in campDays.sorted(by: {$0.date! < $1.date!}){
                let dayNode =  TreeNodeImplementation(name: d.date!.dayOfWeek(), date: d.date!)
                trainingNode.addChild(dayNode)
                let participantDays: [ParticipantDay] = d.participantDays?.allObjects as? [ParticipantDay] ?? []
                for pd in participantDays.sorted(by: {$0.campParticipant!.participant!.uniqueName! < $1.campParticipant!.participant!.uniqueName!}){
                    let pdNode: TreeNode = DayNode(day: pd)
                    dayNode.addChild(pdNode)
                }
                dayNode.rankChildren()
                dayNode.children = dayNode.children.sorted(by: {$0.rank < $1.rank})
            }
            
            let campRaces: [Race] = races?.allObjects as? [Race] ?? []
            for r in campRaces.sorted(by: {$0.date! < $1.date!}){
                let raceNode = TreeNodeImplementation(name: r.name, date: r.date!)
                racesNode.addChild(raceNode)
                let results: [RaceResult] = r.results?.allObjects as? [RaceResult] ?? []
                for result in results.sorted(by: {$0.rank < $1.rank}){
                    let resultNode: TreeNode = RaceResultNode(raceResult: result)
                    raceNode.addChild(resultNode)
                }
                racesNode.rankChildren()
            }
        
        let campsNode = CampNode(name: campName ?? "NOT SET", date: campStart!, training: trainingNode, races: racesNode)
        trainingNode.rankChildren()
        racesNode.rankChildren()
        campsNode.rankChildren()
        
        return campsNode
    }
    
    func generateTreeByParticipant() -> TreeNode{
        let rootNode = TreeNodeImplementation(name: campName ?? "NAME NOT SET", date: campStart!)
        
        for p in campParticipantsArray().sorted(by: {$0.participant!.uniqueName! < $1.participant!.uniqueName!}){
            let node = p.generateTree()
            node.name = p.participant?.displayName ?? "Name NOT SET"
            rootNode.addChild(node)
        }
        rootNode.rankChildren()
        rootNode.children = rootNode.children.sorted(by: {$0.rank < $1.rank})
        return rootNode
        
    }
    
    func rankCompetition(){
        var rank: Int16 = 1
        for cp in orderedForCampPoints(){
            cp.rankInCompetition = rank
            rank += 1
        }
    }

    func campParticipantsArray() -> [CampParticipant]{
        return campParticipants?.allObjects as? [CampParticipant] ?? []
        
    }
    
    private func orderedForCampPoints() -> [CampParticipant]{
        return campParticipantsArray().sorted(by: {
            if ($0.campComplete ? 1:0, $0.campPoints, $0.racesComplete ? 1:0) == ($1.campComplete ? 1:0, $1.campPoints, $1.racesComplete ? 1:0){
                return $0.totalCompetitionSeconds < $1.totalCompetitionSeconds
            }else{
                return ($0.campComplete ? 1:0, $0.campPoints, $0.racesComplete ? 1:0) > ($1.campComplete ? 1:0, $1.campPoints, $1.racesComplete ? 1:0)
            }
        })
    }
    
    private func campDaysArray() -> [Day]{
        return days?.allObjects as? [Day] ?? []
    }
    
}
