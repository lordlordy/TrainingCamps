//
//  Enumerations.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

enum ENTITY: String{
    case CampGroup, Camp, Day, ParticipantDay, Race, RaceResult, Participant, CampParticipant, RaceDefinition
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

}

enum RaceProperty: String{
    case date, name, results
    case includesSwim, includesBike, includesRun
    case isForCampPoints, isGuessYourTime, isHandicap
    case pointsIncrementOverride, pointsBasedOn, pointsForWinOverride, pointsRaceNumber
}

enum RaceResultProperty: String{
    case swimSeconds, bikeSeconds, runSeconds, t1Seconds, t2Seconds
    case handicapSeconds, timeGuessSeconds
    case isRelay, participant
}

enum ParticipantProperty: String{
    case coach, coachingRelationship
    case emailAddress, emailOK
    case firstName, surname, knownAs, gender, uniqueName
    case campGroup, campParticipations
}

enum CampParticipantProperty: String{
    case role, participant, camp
}

enum CampGroupProperty: String{
    case name, camps, participants, raceDefinitions
}

enum RaceDefinitionProperty: String{
    case swimDescription, swimKM, bikeDescription, bikeKM, runDescription, runKM
    case t1Description, t2Description
    case location, name, raceDescription, type
    case races
}
