//
//  Race+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 13/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension Race{
    
    @objc dynamic var name: String{return raceDefinition?.name ?? "RACE DEFINITION NOT SET"}
    @objc dynamic var includesSwim: Bool { return (raceDefinition?.swimKM ?? 0.0) > 0.0}
    @objc dynamic var includesBike: Bool { return (raceDefinition?.bikeKM ?? 0.0) > 0.0}
    @objc dynamic var includesRun:  Bool { return (raceDefinition?.runKM ?? 0.0) > 0.0}

    var pointsMethod: PointsMethod{
        if let pbo = pointsBasedOn{
            if let method = PointsMethod(rawValue: pbo){
                return method
            }
        }
        return PointsMethod.NotAPointsRace
    }
    
    @objc dynamic var dateString: String{
        get{
            let df: DateFormatter = DateFormatter()
            df.dateFormat = DateFormatString.ValidCampDate.rawValue
            if let d = date{
                return df.string(from: d)
            }else{
                return "Date not set"
            }
        }
        set{
            let df: DateFormatter = DateFormatter()
            df.dateFormat = DateFormatString.ValidCampDate.rawValue
            if let d = df.date(from: newValue){
                date = d
            }
        }
    }
    
    @objc dynamic var raceNameString: String{
        get{
            return raceDefinition?.name ?? "Race Definition not set"
        }
        set{
            if let cg = camp?.campGroup{
                raceDefinition = cg.raceDefinition(withName: newValue)
            }
        }
    }
    
}
