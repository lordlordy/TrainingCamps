//
//  Enumerations.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

struct Constants{
    static let lastPlaceRank: Int32 = 9999
    static let milesPerKM: Double = 0.621371
    static let feetPerMetre: Double = 3.280838879986877
}

enum Gender: String{
    case Male, Female, All
    static let Rankable: [Gender] = [Male, Female, All]
}

enum Role: String{
    case Athlete, Coach, Masseuse, Physio
    case RideSupport = "Ride Support"
    case All
    static var AllRoles: [Role] = [Athlete, Coach, Masseuse, Physio, RideSupport]
    static var Rankable: [Role]  = [Athlete, Coach, Masseuse, Physio, RideSupport, All]
}

enum ParticipantFilter: String{
    case All, Completer, Athlete, Coach, Male, Female
    static var AllFilters: [ParticipantFilter] = [All, Completer, Athlete, Coach, Male, Female]
}

enum Activity: String{
    case swim, bike, run, t1, t2
    case total, guessDifference, handicapAdjusted //these are all totals
    static var Eddington: [Activity] = [total, swim, bike, run]
    static var HallOfFame: [Activity] = [total, swim, bike, run]
    
    func validEddingtonUnits() -> [Unit]{
        switch self{
        case .swim: return [Unit.Hours, Unit.KM, Unit.Miles, Unit.Minutes]
        case .t1, .t2: return []
        default: return Unit.Eddington
        }
    }
    
    func hallOfFameUnits() -> [Unit]{
        switch self{
        case .total, .bike, .run: return [Unit.Seconds, Unit.KM, Unit.Ascent, Unit.KPH]
        case .swim: return [Unit.Seconds, Unit.KM, Unit.KPH]
        default: return []
        }
    }
    
}

enum Unit: String{
    case KM, Seconds, Ascent
    case Miles, AscentMetres, AscentFeet, Minutes, Hours
    case KPH, MPH
    static var Rankable: [Unit] = [KM, Seconds, Ascent, KPH]
    static var Eddington: [Unit] = [KM, Miles, Minutes, Hours, AscentMetres, AscentFeet, KPH, MPH]
    
    func factor() -> Double{
        switch self{
        case .KM, .Seconds, .Ascent, .AscentMetres, .KPH: return 1.0
        case .AscentFeet: return Constants.feetPerMetre
        case .Minutes: return 1.0 / 60.0
        case .Hours: return 1.0 / (60.0 * 60.0)
        case .Miles, .MPH: return Constants.milesPerKM
        }
    }
    
}

enum ENTITY: String{
    case CampGroup, Camp, Day, ParticipantDay, Race, RaceResult, Participant, CampParticipant, RaceDefinition
    case Location, CampType, Rank
    case EddingtonNumber
}

enum RaceCompletionStatus: String{
    case Y, DNS, DNF
    case Ydnf = "Y-dnf"
    static let All: [RaceCompletionStatus] = [Y, DNS, DNF, Ydnf]
}

enum CampProperty: String{
    case campEnd, campStart
    case campName, campShortName, campLocation, campType
    case days, races, campParticipants
}

enum DayProperty: String{
    case completionBikeKM, completionBikeKMWithWildcard, earnWildcardBikeKM
    case completionSwimSeconds, completionSwimSecondsWithWildcard, earnWildcardSwimSeconds
    case completionRunSeconds, completionRunSecondsWithWildcard, earnWildcardRunSeconds
    case date
    case participantDays
    
}

enum ParticipantDayProperty: String{
    case participant, brick
    case bikeAscentMetres, bikeKM, bikeSeconds, bikeWildcardUsed
    case runAscentMetres, runKM, runSeconds, runWildcardUsed
    case swimKM, swimSeconds, swimWildcardUsed
    case totalSeconds, totalKM, totalAscentMetres
    case trainingCompletionStatus, swimComplete, bikeComplete, runComplete, dayComplete

}

enum RaceProperty: String{
    case date, raceNameString, results
    case includesSwim, includesBike, includesRun
    case isForCampPoints, isGuessYourTime, isHandicap
    case pointsIncrementOverride, pointsBasedOn, pointsForWinOverride, pointsRaceNumber
    case raceDefinition
    static var CSV: [RaceProperty] = [ date, raceNameString, includesSwim, includesBike, includesRun, isForCampPoints, isGuessYourTime, isHandicap, pointsIncrementOverride, pointsBasedOn, pointsForWinOverride, pointsRaceNumber]
}

enum RaceResultProperty: String{
    
    case swimSeconds, bikeSeconds, runSeconds, t1Seconds, t2Seconds
    case handicapSeconds, guessSeconds
    case isRelay, participant, rankings
    case raceCompletionStatus, campPoints, comments
    case gender, campRole, campName, raceComplete, raceNeededForCompletion
    case completionStatus
    case totalSeconds, guessDifferenceSeconds, handicapAdjustedSeconds
    case displayName, totalRank, swimRank, bikeRank, runRank, t1Rank, t2Rank, guessRank, handicapRank
    case rank, rankGender, rankAfterHandicap, rankOverall, rankGenderOverall, rankParticipant, rankRole, rankBestOnly, rankGenderBestOnly
    
    static var CSV: [RaceResultProperty] = [ displayName, campPoints, completionStatus, totalSeconds, campName, campRole, gender,  swimSeconds, t1Seconds, bikeSeconds,  t2Seconds,runSeconds, handicapSeconds, guessSeconds, guessDifferenceSeconds, handicapAdjustedSeconds, isRelay, raceCompletionStatus, comments, raceComplete, raceNeededForCompletion, rank, rankGender, rankAfterHandicap, rankOverall, rankGenderOverall, rankParticipant, rankRole, rankBestOnly, rankGenderBestOnly]
}

enum ParticipantProperty: String{
    case coach, coachingRelationship
    case emailAddress, emailOK
    case firstName, surname, knownAs, gender, uniqueName
    case campGroup, campParticipations, eddingtonNumbers
}

enum CampParticipantProperty: String{
    case participant, camp
    case role, bonusPoints, isInPointsCompetition, rankInCompetition
    case trainingComplete, racesComplete, campComplete
    case campPoints, totalKM, totalSeconds, totalAscentMetres
    case swimKM, swimSeconds
    case bikeKM, bikeSeconds, bikeAscentMetres
    case runKM, runSeconds, runAscentMetres, bricks
    case totalCompetitionSeconds
    case campParticipantNameString, completionStatus
    case overallRankTime, overallRankTimeGender, campRankTime
    case overallRankSwimKM, overallRankSwimKMGender, campRankSwimKM
    case overallRankBikeKM, overallRankBikeKMGender, campRankBikeKM
    case overallRankRunKM, overallRankRunKMGender, campRankRunKM
    
    static var CSV: [CampParticipantProperty] = [campParticipantNameString, completionStatus, campPoints, rankInCompetition, totalSeconds, totalKM,  totalAscentMetres, swimSeconds, swimKM, bikeSeconds, bikeKM, bikeAscentMetres, bricks, runSeconds, runKM, runAscentMetres, role, bonusPoints, isInPointsCompetition, trainingComplete, racesComplete, campComplete,   totalCompetitionSeconds ,  overallRankTime, overallRankTimeGender, campRankTime, overallRankSwimKM, overallRankSwimKMGender, campRankSwimKM, overallRankBikeKM, overallRankBikeKMGender, campRankBikeKM, overallRankRunKM, overallRankRunKMGender, campRankRunKM]
}

enum CampGroupProperty: String{
    case name, camps, participants, raceDefinitions, locations, campTypes
}

enum RaceDefinitionProperty: String{
    case swimDescription, swimKM, bikeDescription, bikeKM, runDescription, runKM
    case t1Description, t2Description
    case location, name, raceDescription, type
    case races, locationString
}


enum Coach: String{
    case Jo, Ste
}

enum DateFormatString: String{
    case ValidCampDate = "EEE dd MMM yy"
    case DayOfWeekOnly = "EEEE"
}

enum CoachingRelationship: String{
    case None
    case FormerAthlete = "Former Athlete"
    case CurrentAthlete = "Current Athlete"
}

enum PointsMethod: String{
    case NotAPointsRace = "Not A Points Race"
    case Handicap
    case GuessYourTime = "Guess Your Time"
    case OutrightResult = "Outright Result"
    static let All: [PointsMethod] = [NotAPointsRace, Handicap, GuessYourTime, OutrightResult]
}

enum UserDefaultKey: String{
    case swimColour, bikeColour, runColour
}

enum RaceType: String{
    case Swim, Bike, Run, Aquathon, Triathlon, Duathlon
    static let All: [RaceType] = [ Swim, Bike, Run, Aquathon, Triathlon, Duathlon]
}

enum EddingtonNumberProperty: String{
    case code, activity, unit, value, plusOne
}


