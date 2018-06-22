//
//  CampParticipantsRacesViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa
//DEPRECATED
class CampParticipantsRacesViewController: NSViewController, CampParticipantViewControllerProtocol{
    
//    private enum ColumnID: String{
//        case swim, swimRank, bike, bikeRank, run, runRank
//        case total, t1, t1Rank, t2, t2Rank, isRelay
//        case guess, guessDiff, guessRank
//        case handicap, handicapRank, points , handicapEstimated, timeAfterHandicap
//    }
//
//    @IBOutlet weak var participantsRacesTableView: NSTableView!
//
    @objc dynamic var campParticipant: CampParticipant?
    
//    @objc func showAllColumns(_ sender: Any?){
//        for col in participantsRacesTableView.tableColumns{
//            col.isHidden = false
//        }
//    }
    
    func setCampParticipant(_ campParticipant: CampParticipant) {
        self.campParticipant = campParticipant
//        updateColumns()
    }
    
    
//    private func updateColumns(){
//        if let results = campParticipant?.raceResults?.allObjects as? [RaceResult]{
//            let swim: Bool = results.reduce(false, {$0 || ($1.race?.includesSwim ?? false)})
//            let bike: Bool = results.reduce(false, {$0 || ($1.race?.includesBike ?? false)})
//            let run: Bool = results.reduce(false, {$0 || ($1.race?.includesRun ?? false)})
//            let guess: Bool = results.reduce(false, {$0 || ($1.race?.isGuessYourTime ?? false)})
//            let handicap: Bool = results.reduce(false, {$0 || ($1.race?.isHandicap ?? false)})
//            let points: Bool = results.reduce(false, {$0 || ($1.race?.isForCampPoints ?? false)})
//            let disciplineCount: Int = results.reduce(0, {max($0, ($1.race?.raceDefinition?.disciplineCount ?? 0))})
//            let isRelay: Bool = results.reduce(false, {$0 || $1.isRelay})
//            let isEstimate: Bool = results.reduce(false, {$0 || $1.wasHandicapEstimate})
//
//            for col in participantsRacesTableView.tableColumns{
//                switch col.identifier.rawValue{
//                case ColumnID.swim.rawValue, ColumnID.swimRank.rawValue:
//                    col.isHidden = !swim
//                case ColumnID.bike.rawValue, ColumnID.bikeRank.rawValue:
//                    col.isHidden = !bike
//                case ColumnID.run.rawValue, ColumnID.runRank.rawValue:
//                    col.isHidden = !run
//                case ColumnID.total.rawValue, ColumnID.t1.rawValue, ColumnID.t1Rank.rawValue:
//                    col.isHidden = disciplineCount < 2
//                case ColumnID.t2.rawValue, ColumnID.t2Rank.rawValue:
//                    col.isHidden = disciplineCount < 3
//                case ColumnID.guess.rawValue, ColumnID.guessDiff.rawValue, ColumnID.guessRank.rawValue:
//                    col.isHidden = !guess
//                case ColumnID.handicap.rawValue, ColumnID.handicapRank.rawValue, ColumnID.timeAfterHandicap.rawValue:
//                    col.isHidden = !handicap
//                case ColumnID.points.rawValue:
//                    col.isHidden = !points
//                case ColumnID.isRelay.rawValue:
//                    col.isHidden = !isRelay
//                case ColumnID.handicapEstimated.rawValue:
//                    col.isHidden = !isEstimate
//                default:
//                    col.isHidden = false
//                }
//            }
//
//        }
//    }
    
}
