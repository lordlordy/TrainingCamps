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
    
    @objc dynamic var pointsForAWin: Int{
        if pointsForWinOverride > 0.0{
            return Int(pointsForWinOverride)
        }else{
            return camp!.pointsForAWin
        }
    }
    @objc dynamic var pointsIncrement: Int{
        if pointsIncrementOverride > 0.0{
            return Int(pointsIncrementOverride)
        }else{
            return 1
        }
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
    
    func rank(){
        let ranker = RaceRanker() // should move this to generic Ranker.swift
        ranker.rank(self)
        generatePoints()
    }
    
    private func generatePoints(){
        if isForCampPoints{
            let pointsResults = resultsOrderedForPoints().filter({$0.campParticipant!.isInPointsCompetition})
            var points: Int16 = Int16(pointsForAWin)
            let increment: Int16 = Int16(pointsIncrement)
            
            for r in pointsResults{
                if r.raceCompletionStatus == RaceCompletionStatus.Y.rawValue{
                    r.campPoints = points
                    points -= increment
                }else{
                    r.campPoints = 0
                }
            }
        }
    }
    
    private func resultsOrderedForPoints() -> [RaceResult]{
        if let pointsMethod = pointsBasedOn{
            switch pointsMethod{
            case PointsMethod.GuessYourTime.rawValue:
                return raceResultsArray().sorted(by: {$0.guessRank.camp < $1.guessRank.camp})
            case PointsMethod.OutrightResult.rawValue:
                return raceResultsArray().sorted(by: {$0.rank < $1.rank})
            case PointsMethod.Handicap.rawValue:
                return raceResultsArray().sorted(by: {$0.handicapRank.camp < $1.handicapRank.camp})
            default:
                return []
            }
        }
        return []
        
    }
    
    private func raceResultsArray() -> [RaceResult]{
        return results?.allObjects as? [RaceResult] ?? []
    }
    
}
