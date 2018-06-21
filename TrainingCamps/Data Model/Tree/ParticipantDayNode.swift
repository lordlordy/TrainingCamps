//
//  ParticipantDayNode.swift
//  TrainingCamps
//
//  Created by Steven Lord on 14/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class ParticipantDayNode: DayNode{

    
    override init(day: ParticipantDay) {
        super.init(day: day)
        let df = DateFormatter.init()
        df.dateFormat = "EEEE"
        name = df.string(from: day.day!.date!)
    }
    
}
