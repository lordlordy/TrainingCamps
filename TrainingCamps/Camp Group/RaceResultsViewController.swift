//
//  RaceResultsViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class RaceResultsViewController: NSViewController, RaceResultsViewControllerProtocol{
    
    private enum ColumnID: String{
        case swim, swimRank, bike, bikeRank, run, runRank
        case total, t1, t1Rank, t2, t2Rank, isRelay
        case guess, guessDiff, guessRank
        case handicap, handicapRank, points , handicapEstimated, timeAfterHandicap
    }
    
    @objc dynamic var raceResults: NSSet?
    
    func setRaceResults(_ raceResults: NSSet) {
        self.raceResults = raceResults
        updateColumns()
    }
    
    
    @IBOutlet weak var participantsRacesTableView: NSTableView!
    
    @objc func showAllColumns(_ sender: Any?){
        for col in participantsRacesTableView.tableColumns{
            col.isHidden = false
        }
    }
    

    private func updateColumns(){
        
        if let rr = raceResults?.allObjects as? [RaceResult]{
            let swim: Bool = rr.reduce(false, {$0 || ($1.race?.includesSwim ?? false)})
            let bike: Bool = rr.reduce(false, {$0 || ($1.race?.includesBike ?? false)})
            let run: Bool = rr.reduce(false, {$0 || ($1.race?.includesRun ?? false)})
            let guess: Bool = rr.reduce(false, {$0 || ($1.race?.isGuessYourTime ?? false)})
            let handicap: Bool = rr.reduce(false, {$0 || ($1.race?.isHandicap ?? false)})
            let points: Bool = rr.reduce(false, {$0 || ($1.race?.isForCampPoints ?? false)})
            let disciplineCount: Int = rr.reduce(0, {max($0, ($1.race?.raceDefinition?.disciplineCount ?? 0))})
            let isRelay: Bool = rr.reduce(false, {$0 || $1.isRelay})
            let isEstimate: Bool = rr.reduce(false, {$0 || $1.wasHandicapEstimate})
            
            for col in participantsRacesTableView.tableColumns{
                switch col.identifier.rawValue{
                case ColumnID.swim.rawValue, ColumnID.swimRank.rawValue:
                    col.isHidden = !swim
                case ColumnID.bike.rawValue, ColumnID.bikeRank.rawValue:
                    col.isHidden = !bike
                case ColumnID.run.rawValue, ColumnID.runRank.rawValue:
                    col.isHidden = !run
                case ColumnID.total.rawValue, ColumnID.t1.rawValue, ColumnID.t1Rank.rawValue:
                    col.isHidden = disciplineCount < 2
                case ColumnID.t2.rawValue, ColumnID.t2Rank.rawValue:
                    col.isHidden = disciplineCount < 3
                case ColumnID.guess.rawValue, ColumnID.guessDiff.rawValue, ColumnID.guessRank.rawValue:
                    col.isHidden = !guess
                case ColumnID.handicap.rawValue, ColumnID.handicapRank.rawValue, ColumnID.timeAfterHandicap.rawValue:
                    col.isHidden = !handicap
                case ColumnID.points.rawValue:
                    col.isHidden = !points
                case ColumnID.isRelay.rawValue:
                    col.isHidden = !isRelay
                case ColumnID.handicapEstimated.rawValue:
                    col.isHidden = !isEstimate
                default:
                    col.isHidden = false
                }
            }
        }
        

    }
    
}
