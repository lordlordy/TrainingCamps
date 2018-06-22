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

enum Activity: String{
    case swim, bike, run, t1, t2
    case total, guessDifference, handicapAdjusted //these are all totals
//    static var Rankable: [Activity] = [swim, bike, run, t1, t2, total, guessDifference, handicapAdjusted]
}

enum Unit: String{
    case KM, Seconds, Ascent
    static var Rankable: [Unit] = [KM, Seconds, Ascent]
}

enum ENTITY: String{
    case CampGroup, Camp, Day, ParticipantDay, Race, RaceResult, Participant, CampParticipant, RaceDefinition
    case Location, CampType, Rank
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
}

enum RaceResultProperty: String{
    case swimSeconds, bikeSeconds, runSeconds, t1Seconds, t2Seconds
    case handicapSeconds, guessSeconds
    case isRelay, participant, rankings
}

enum ParticipantProperty: String{
    case coach, coachingRelationship
    case emailAddress, emailOK
    case firstName, surname, knownAs, gender, uniqueName
    case campGroup, campParticipations
}

enum CampParticipantProperty: String{
    case role, participant, camp, bonusPoints  
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


