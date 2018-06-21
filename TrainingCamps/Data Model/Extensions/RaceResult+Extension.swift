//
//  RaceResult+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 14/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension RaceResult{
    
    @objc dynamic var uniqueName: String{
        return campParticipant?.participant?.uniqueName ?? "PARTICIPANT NOT SET"
    }
    
    @objc dynamic var campComplete: Bool{
        if let status = raceCompletionStatus{
            return status == RaceCompletionStatus.Y.rawValue || status == RaceCompletionStatus.Ydnf.rawValue
        }
        return false
    }
    
    @objc dynamic var completionStatus: String{ return campComplete ? "Yes":"No"}
    @objc dynamic var totalSeconds: Double{ return swimSeconds + bikeSeconds + runSeconds}
    @objc dynamic var guessDiff: Double { return abs(totalSeconds - timeGuessSeconds)}
    
    @objc dynamic var secondsAfterHandicap: Double { return totalSeconds == 0.0 ? 0.0 : totalSeconds + handicapSeconds}

    @objc dynamic var displayName: String{
        get{
            return campParticipant?.participant?.displayName ?? "Name Not Set"
        }
        set{
            if let c = race?.camp{
                if let p = c.campParticipant(forDisplayName: newValue){
                    campParticipant = p
                }
            }
        }
    }
    
}
