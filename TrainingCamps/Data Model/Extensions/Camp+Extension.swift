//
//  Camp+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 13/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension Camp: TrainingValuesProtocol{
    
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
    @objc dynamic var pointsForAWin: Int { return campParticipantsArray().filter({$0.isInPointsCompetition}).count}
    
    @objc var totalKM:              Double { return valueFor(.total, .KM)}
    @objc var swimKM:               Double { return valueFor(.swim, .KM)}
    @objc var bikeKM:               Double { return valueFor(.bike, .KM)}
    @objc var runKM:                Double { return valueFor(.run, .KM)}
    @objc var totalAscentMetres:    Double { return valueFor(.total, .Ascent) }
    @objc var bikeAscentMetres:     Double { return valueFor(.bike, .Ascent)}
    @objc var runAscentMetres:      Double { return valueFor(.run, .Ascent)}
    @objc var totalSeconds:         Double { return valueFor(.total, .Seconds)}
    @objc var swimSeconds:          Double { return valueFor(.swim, .Seconds)}
    @objc var bikeSeconds:          Double { return valueFor(.bike, .Seconds)}
    @objc var runSeconds:           Double { return valueFor(.run, .Seconds)}
    
    
    @objc var  bricks: Int {return campDaysArray().reduce(0, {$0 + $1.bricks})}
    
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
    
    @objc dynamic var allTimeCampTimeTopThree: [HallOfFameResult]{
        if let cg = campGroup{
            let topTens = cg.topTen(forActivity: .total, unit: .Seconds, isDay: false)
            return topTens.overall.filter({$0.rank < 6})
        }
        return []
    }

    @objc dynamic var allTimeCampSwimKMTopThree: [HallOfFameResult]{
        if let cg = campGroup{
            let topTens = cg.topTen(forActivity: .swim, unit: .KM, isDay: false)
            return topTens.overall.filter({$0.rank < 4})
        }
        return []
    }
    
    @objc dynamic var allTimeCampBikeKMTopThree: [HallOfFameResult]{
        if let cg = campGroup{
            let topTens = cg.topTen(forActivity: .bike, unit: .KM, isDay: false)
            return topTens.overall.filter({$0.rank < 4})
        }
        return []
    }
    
    @objc dynamic var allTimeCampRunKMTopThree: [HallOfFameResult]{
        if let cg = campGroup{
            let topTens = cg.topTen(forActivity: .run, unit: .KM, isDay: false)
            return topTens.overall.filter({$0.rank < 4})
        }
        return []
    }
    
    @objc dynamic var campTimeTopThree: [CampParticipant]{
        return campParticipantsArray().filter({$0.campRankTime < 4}).sorted(by: {$0.campRankTime < $1.campRankTime})
    }
    
    func getRacesArray() -> [Race]{
        return races?.allObjects as? [Race] ?? []
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

    func valueFor(_ a: Activity, _ u: Unit) -> Double{
        return valueFor(a.rawValue, u.rawValue)
    }
    
    func valueFor(_ activity: String, _ unit: String) -> Double{
        return campParticipantsArray().reduce(0.0, {$0 + $1.valueFor(activity,unit)})
    }
    
    func participantDaysArray() -> [ParticipantDay]{
        var result: [ParticipantDay] = []
        for cp in campParticipantsArray(){
            result.append(contentsOf: cp.getDays())
        }
        return result
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
    
    func campDaysArray() -> [Day]{
        return days?.allObjects as? [Day] ?? []
    }
    
}
