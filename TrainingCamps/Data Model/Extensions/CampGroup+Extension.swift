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
        result.append((Activity.total, Unit.Seconds))
        result.append((Activity.total, Unit.KM))
        result.append((Activity.total, Unit.Ascent))
        result.append((Activity.total, Unit.KPH))
        result.append((Activity.swim, Unit.Seconds))
        result.append((Activity.swim, Unit.KM))
        result.append((Activity.swim, Unit.KPH))
        result.append((Activity.bike, Unit.Seconds))
        result.append((Activity.bike, Unit.KM))
        result.append((Activity.bike, Unit.Ascent))
        result.append((Activity.bike, Unit.KPH))
        result.append((Activity.run, Unit.Seconds))
        result.append((Activity.run, Unit.KM))
        result.append((Activity.run, Unit.Ascent))
        result.append((Activity.run, Unit.KPH))
        return result
    }
    
    var earliestCampStart: Date{
        let orderedCamps: [Camp] = campsArray().sorted(by: {$0.campStart ?? Date() < $1.campStart ?? Date()})
        if orderedCamps.count > 0{
            return orderedCamps[0].campStart ?? Date()
        }else{
            return Date()
        }
    }
    
    @objc var totalKM:      Double { return campsArray().reduce(0.0, {$0 + $1.totalKM}) }
    @objc var swimKM:       Double { return campsArray().reduce(0.0, {$0 + $1.swimKM}) }
    @objc var bikeKM:       Double { return campsArray().reduce(0.0, {$0 + $1.bikeKM}) }
    @objc var runKM:        Double { return campsArray().reduce(0.0, {$0 + $1.runKM}) }
    @objc var totalSeconds: Double { return campsArray().reduce(0.0, {$0 + $1.totalSeconds}) }
    @objc var swimSeconds:  Double { return campsArray().reduce(0.0, {$0 + $1.swimSeconds}) }
    @objc var bikeSeconds:  Double { return campsArray().reduce(0.0, {$0 + $1.bikeSeconds}) }
    @objc var runSeconds:   Double { return campsArray().reduce(0.0, {$0 + $1.runSeconds}) }
    
    
    @objc var participantEddingtonNumbers: [EddingtonNumber]{ return participantEddingtonNumbersArray()}
    
    private var dayTotalSecondsStdDevMeanSum: (stdDev: Double, mean: Double, total: Double){
        return Maths().stdDevMeanTotal(participantDaysArray().map({$0.totalSeconds}))
    }
    private var daySwimKMStdDevMeanSum: (stdDev: Double, mean: Double, total: Double){
        return Maths().stdDevMeanTotal(participantDaysArray().map({$0.swimKM}))
    }
    private var dayBikeKMStdDevMeanSum: (stdDev: Double, mean: Double, total: Double){
        return Maths().stdDevMeanTotal(participantDaysArray().map({$0.bikeKM}))
    }
    private var dayRunKMStdDevMeanSum: (stdDev: Double, mean: Double, total: Double){
        return Maths().stdDevMeanTotal(participantDaysArray().map({$0.runKM}))
    }
    private var campTotalSecondsStdDevMeanSum: (stdDev: Double, mean: Double, total: Double){
        return Maths().stdDevMeanTotal(campParticipantsArray().map({$0.totalSeconds}))
    }
    private var campSwimKMStdDevMeanSum: (stdDev: Double, mean: Double, total: Double){
        return Maths().stdDevMeanTotal(campParticipantsArray().map({$0.swimKM}))
    }
    private var campBikeKMStdDevMeanSum: (stdDev: Double, mean: Double, total: Double){
        return Maths().stdDevMeanTotal(campParticipantsArray().map({$0.bikeKM}))
    }
    private var campRunKMStdDevMeanSum: (stdDev: Double, mean: Double, total: Double){
        return Maths().stdDevMeanTotal(campParticipantsArray().map({$0.runKM}))
    }
    

    func rank(){
        let start = Date()
        let ranker: Ranker = Ranker()
        let days: [Rankable] = participantDaysArray()
        let participantsCamps: [Rankable] =  campParticipantsArray()
        
        ranker.rank(days, forRankUnits: rankUnits, isAscending: false)
        ranker.rank(participantsCamps, forRankUnits: rankUnits, isAscending: false)
        
        rankParticipantEddingtonNumbers()
        
        print("Calculating training ranks took \(Int(Date().timeIntervalSince(start)))s")
    }
    
    func rankParticipantEddingtonNumbers(){
        // sort by code, then by value (descending) then by plusOne ascending
        let ordered = participantEddingtonNumbers.sorted(by: {($0.code, $0.value, -1 * $0.plusOne) > ($1.code, $1.value, -1 * $1.plusOne)})
        let female = ordered.filter({$0.participant?.gender == Gender.Female.rawValue})
        let male = ordered.filter({$0.participant?.gender == Gender.Male.rawValue})
        
        var rank: Int32 = 1
        
        var previousCode: String = ""
        for o in ordered{
            if previousCode != o.code{
                previousCode = o.code
                rank = 1
            }
            o.rank = rank
            rank += 1
        }
        
        //female
        rank = 1
        previousCode = ""
        for o in female{
            if previousCode != o.code{
                previousCode = o.code
                rank = 1
            }
            o.rankGender = rank
            rank += 1
        }
        
        rank = 1
        previousCode = ""
        for o in male{
            if previousCode != o.code{
                previousCode = o.code
                rank = 1
            }
            o.rankGender = rank
            rank += 1
        }
        

        
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
        return raceDefinitionArray().filter({$0.location?.name ?? "" == l.name})
    }
    
    func valueFor(_ activity: Activity, _ unit: Unit) -> Double{
        return valueFor(activity.rawValue, unit.rawValue)
    }
    
    func valueFor(_ activity: String, _ unit: String) -> Double{
        return campsArray().reduce(0.0, {$0 + $1.valueFor(activity,unit)})
    }
    
    
    
    func raceDefinitionArray() -> [RaceDefinition]{
        let a = raceDefinitions?.allObjects as? [RaceDefinition] ?? []
        return a
//not sure why I was sorting this
        //        return a.sorted(by: {($0.location!.name!, $0.name!) < ($1.location!.name!, $1.name!)})
    }
    
    func topTenEddingtonNumbers(forActivity a: Activity, unit u: Unit)-> (overall: [HallOfFameResult], female: [HallOfFameResult], male: [HallOfFameResult]){
        
        let filtered: [EddingtonNumber] = individualEddingtonNumbers().filter({$0.activity! == a.rawValue && $0.unit! == u.rawValue})
        
        var oHall: [HallOfFameResult] = []
        var fHall: [HallOfFameResult] = []
        var mHall: [HallOfFameResult] = []
        
        for i in filtered.filter({$0.rank < 11}).sorted(by: {$0.rank < $1.rank}){
            oHall.append(HallOfFameResult.init(i.rank, i.participant!.displayName, edNum: i.value, plusOne: i.plusOne))
        }
        
        for i in filtered.filter({$0.rankGender < 11 && $0.participant!.gender! == Gender.Female.rawValue}).sorted(by: {$0.rankGender < $1.rankGender}){
            fHall.append(HallOfFameResult.init(i.rankGender, i.participant!.displayName, edNum: i.value, plusOne: i.plusOne))
        }
        
        for i in filtered.filter({$0.rankGender < 11 && $0.participant!.gender! == Gender.Male.rawValue}).sorted(by: {$0.rankGender < $1.rankGender}){
            mHall.append(HallOfFameResult.init(i.rankGender, i.participant!.displayName, edNum: i.value, plusOne: i.plusOne))
        }
        
        return (oHall, fHall, mHall)
        
    }
    
    func topTen(forActivity a: Activity, unit u: Unit, isDay: Bool) -> (overall: [HallOfFameResult], female: [HallOfFameResult], male: [HallOfFameResult]){

        if isDay{
            return dayTopTen(forActivity: a, unit: u)
        }else{
            return campTopTen(forActivity: a, unit: u)
        }
        
    }

    func topTen(forLocation l: Location, activity a: Activity, unit u: Unit, isDay: Bool) -> (overall: [Rank], female: [Rank], male: [Rank]){
        
        if isDay{
            return dayTopTen(forLocation:l, activity: a, unit: u)
        }else{
            return campTopTen(forLocation:l, activity: a, unit: u)
        }
        
    }
    
    private func individualEddingtonNumbers() -> [EddingtonNumber]{
        var result: [EddingtonNumber] = []
        for p in participantArray(){
            result.append(contentsOf: p.eddingtonNumbers?.allObjects as? [EddingtonNumber] ?? [])
        }
        return result
    }
    
    private func dayTopTen(forLocation l: Location, activity a: Activity, unit u: Unit) -> (overall: [Rank], female: [Rank], male: [Rank]){
        let filteredRanks: [Rank] = dayRanks().filter({$0.participantDay!.campParticipant!.camp!.location == l && $0.activity! == a.rawValue && $0.unit! == u.rawValue}).sorted(by: {$0.bestOnly < $1.bestOnly})
        let female: [Rank] = filteredRanks.filter({$0.participantDay!.campParticipant!.participant!.gender! == Gender.Female.rawValue})
        let male: [Rank] = filteredRanks.filter({$0.participantDay!.campParticipant!.participant!.gender! == Gender.Male.rawValue})
        
        var o: [Rank] = []
        var f: [Rank] = []
        var m: [Rank] = []
        
        //pull together top 10 - they are in rank order already so...
        for i in 0...9{
            if filteredRanks.count > i{
                o.append(filteredRanks[i])
            }
            if female.count > i{
                f.append(female[i])
            }
            if male.count > i{
                m.append(male[i])
            }
        }
        
        return (o,f,m)
        
    }
    
    private func campTopTen(forLocation l: Location, activity a: Activity, unit u: Unit) -> (overall: [Rank], female: [Rank], male: [Rank]){
        let filteredRanks: [Rank] = campRanks().filter({$0.campParticipant!.camp!.location == l && $0.activity! == a.rawValue && $0.unit! == u.rawValue}).sorted(by: {$0.bestOnly < $1.bestOnly})
        let female: [Rank] = filteredRanks.filter({$0.campParticipant!.participant!.gender! == Gender.Female.rawValue})
        let male: [Rank] = filteredRanks.filter({$0.campParticipant!.participant!.gender! == Gender.Male.rawValue})
        
        var o: [Rank] = []
        var f: [Rank] = []
        var m: [Rank] = []
        
        //pull together top 10 - they are in rank order already so...
        for i in 0...9{
            if filteredRanks.count > i{
                o.append(filteredRanks[i])
            }
            if female.count > i{
                f.append(female[i])
            }
            if male.count > i{
                m.append(male[i])
            }
        }
        
        return (o,f,m)
        
    }
    
    private func dayTopTen(forActivity a: Activity, unit u: Unit) -> (overall: [HallOfFameResult], female: [HallOfFameResult], male: [HallOfFameResult]){
        
        let filteredRanks: [Rank] = dayRanks().filter({$0.activity! == a.rawValue && $0.unit! == u.rawValue})
        let overall: [Rank] = filteredRanks.filter({$0.bestOnly < 11}).sorted(by: {$0.bestOnly < $1.bestOnly})
        let female: [Rank] = filteredRanks.filter({$0.bestOnlyGender < 11 && $0.participantDay!.campParticipant!.participant!.gender! == Gender.Female.rawValue}).sorted(by: {$0.bestOnlyGender < $1.bestOnlyGender})
        let male: [Rank] = filteredRanks.filter({$0.bestOnlyGender < 11 && $0.participantDay!.campParticipant!.participant!.gender! == Gender.Male.rawValue}).sorted(by: {$0.bestOnlyGender < $1.bestOnlyGender})
        
        var oHall: [HallOfFameResult] = []
        var fHall: [HallOfFameResult] = []
        var mHall: [HallOfFameResult] = []
        
        for o in overall{
            oHall.append(HallOfFameResult(o.bestOnly, o.participantDay!.campParticipant!.participant!.displayName, o.participantDay!.campParticipant!.camp!.campShortName!, value: o.value, unit: u))
        }
        for f in female{
            fHall.append(HallOfFameResult(f.bestOnlyGender, f.participantDay!.campParticipant!.participant!.displayName, f.participantDay!.campParticipant!.camp!.campShortName!, value: f.value, unit: u))
        }
        for m in male{
            mHall.append(HallOfFameResult(m.bestOnlyGender, m.participantDay!.campParticipant!.participant!.displayName, m.participantDay!.campParticipant!.camp!.campShortName!, value: m.value, unit: u))
        }
        
        return (oHall, fHall, mHall)
        
    }
    
    private func campTopTen(forActivity a: Activity, unit u: Unit) -> (overall: [HallOfFameResult], female: [HallOfFameResult], male: [HallOfFameResult]){
        
        let filteredRanks: [Rank] = campRanks().filter({$0.activity! == a.rawValue && $0.unit! == u.rawValue})
        let overall: [Rank] = filteredRanks.filter({$0.bestOnly < 11}).sorted(by: {$0.bestOnly < $1.bestOnly})
        let female: [Rank] = filteredRanks.filter({$0.bestOnlyGender < 11 && $0.campParticipant!.participant!.gender! == Gender.Female.rawValue}).sorted(by: {$0.bestOnlyGender < $1.bestOnlyGender})
        let male: [Rank] = filteredRanks.filter({$0.bestOnlyGender < 11 && $0.campParticipant!.participant!.gender! == Gender.Male.rawValue}).sorted(by: {$0.bestOnlyGender < $1.bestOnlyGender})
        
        var oHall: [HallOfFameResult] = []
        var fHall: [HallOfFameResult] = []
        var mHall: [HallOfFameResult] = []
        
        for o in overall{
            oHall.append(HallOfFameResult(o.bestOnly, o.campParticipant!.participant!.displayName, o.campParticipant!.camp!.campShortName!, value: o.value, unit: u))
        }
        for f in female{
            fHall.append(HallOfFameResult(f.bestOnlyGender, f.campParticipant!.participant!.displayName, f.campParticipant!.camp!.campShortName!, value: f.value, unit: u))
        }
        for m in male{
            mHall.append(HallOfFameResult(m.bestOnlyGender, m.campParticipant!.participant!.displayName, m.campParticipant!.camp!.campShortName!, value: m.value, unit: u))
        }
        
        return (oHall, fHall, mHall)
        
    }
    
    private func campRanks() -> [Rank]{
        var result: [Rank] = []
        for c in campParticipantsArray(){
            result.append(contentsOf: c.rankings?.allObjects as? [Rank] ?? [])
        }
        return result
    }

    private func dayRanks() -> [Rank]{
        var result: [Rank] = []
        for d in participantDaysArray(){
            result.append(contentsOf: d.rankings?.allObjects as? [Rank] ?? [])
        }
        return result
    }
    
    private func participantEddingtonNumbersArray() -> [EddingtonNumber]{
        var result: [EddingtonNumber] = []
        for p in participantArray(){
            result.append(contentsOf: p.eddingtonNumbers?.allObjects as? [EddingtonNumber] ?? [])
        }
        return result
    }
    
    func percentile(forActivity a: Activity, andUnit u: Unit, isCamp: Bool, withValue v: Double) -> Double{
        let stdDevMean = stdDevMeanSum(forActivity: a, andUnit: u, isCamp: isCamp)
        let stdDevsFromMean = (v - stdDevMean.mean) / stdDevMean.stdDev
        let percentile = Maths().phi(stdDev: stdDevsFromMean)
        return percentile
    }
    
    private func stdDevMeanSum(forActivity a: Activity, andUnit u: Unit, isCamp: Bool) -> (stdDev: Double, mean: Double, total: Double){
        if isCamp{
            if a == Activity.total && u == Unit.Seconds{
                return campTotalSecondsStdDevMeanSum
            }
            if u == Unit.KM{
                switch a{
                case .swim: return campSwimKMStdDevMeanSum
                case .bike: return campBikeKMStdDevMeanSum
                case .run: return campRunKMStdDevMeanSum
                default: return (0.0,0.0,0.0)
                }
            }
        }else{
            if a == Activity.total && u == Unit.Seconds{
                return dayTotalSecondsStdDevMeanSum
            }
            if u == Unit.KM{
                switch a{
                case .swim: return daySwimKMStdDevMeanSum
                case .bike: return dayBikeKMStdDevMeanSum
                case .run: return dayRunKMStdDevMeanSum
                default: return (0.0,0.0,0.0)
                }
            }
        }
        
       return (0.0,0.0,0.0)
        
    }
    
}
