//
//  SingleRaceResultsViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class SingleRaceResultsViewController: NSViewController, RaceResultsViewControllerProtocol, RaceViewControllerProtocol, NSComboBoxDataSource{

    
    
    enum ColumnID: String{
        case swim, t1, bike, t2, run, handicap, adjTotal, guess, guessDiff
        case handicapEstimated, rankAfterHandicap, points
        case swimRank, t1Rank, bikeRank, t2Rank, runRank, rankGuess
        case isRelay, total
    }
    
    @objc dynamic var raceResults: NSSet?
    @objc dynamic var race: Race?

    
    @objc dynamic var resultsEditable: Bool {
        return race != nil
        
    }
    
    @IBOutlet weak var raceResultsTableView: NSTableView!
    
    
    @IBAction func showAllColumns(_ sender: Any?){
        for col in raceResultsTableView.tableColumns{
            col.isHidden = false
        }
    }
    
    func setRace(_ race: Race) {
        self.race = race
        raceResults = race.mutableSetValue(forKey: RaceProperty.results.rawValue)
        updateColumns()
    }

//    func setCampGroup(_ campGroup: CampGroup) {
//        self.campGroup = campGroup
//    }
    
    func setRaceResults(_ raceResults: NSSet) {
        self.raceResults = raceResults
        updateColumns()
    }
    
    
    //MARK: - NSComboBoxDataSource
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        
        if let rr = getFirstRaceResult(){
            if let displayNames: [String] = rr.race?.raceDefinition?.campGroup?.participantArray().map({$0.displayName}){
                if index < displayNames.count{
                    return displayNames[index]
                }
            }
        }
        
        return nil
        
    }
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return getFirstRaceResult()?.race?.raceDefinition?.campGroup?.participantArray().count ?? 0
    }
    
    private func updateColumns(){
        if let race = getFirstRaceResult()?.race{
            let disciplineCount: Int = race.raceDefinition?.disciplineCount ?? 0
            
            for col in raceResultsTableView.tableColumns{
                switch col.identifier.rawValue{
                case ColumnID.swim.rawValue:
                    col.isHidden = !race.includesSwim
                case ColumnID.swimRank.rawValue:
                    col.isHidden = (disciplineCount == 1) || !race.includesSwim
                case ColumnID.bike.rawValue:
                    col.isHidden = !race.includesBike
                case ColumnID.bikeRank.rawValue:
                    col.isHidden = (disciplineCount == 1) || !race.includesBike
                case ColumnID.t2.rawValue, ColumnID.t2Rank.rawValue:
                    col.isHidden = disciplineCount < 3
                case ColumnID.run.rawValue:
                    col.isHidden = !race.includesRun
                case ColumnID.runRank.rawValue:
                    col.isHidden = (disciplineCount == 1) || !race.includesRun
                case ColumnID.handicap.rawValue, ColumnID.handicapEstimated.rawValue, ColumnID.rankAfterHandicap.rawValue, ColumnID.adjTotal.rawValue:
                    col.isHidden = !race.isHandicap
                case ColumnID.guess.rawValue, ColumnID.guessDiff.rawValue, ColumnID.rankGuess.rawValue:
                    col.isHidden = !race.isGuessYourTime
                case ColumnID.points.rawValue:
                    col.isHidden = !race.isForCampPoints
                case ColumnID.total.rawValue, ColumnID.isRelay.rawValue, ColumnID.t1.rawValue, ColumnID.t1Rank.rawValue:
                    col.isHidden = disciplineCount == 1
                default:
                    col.isHidden = false
                }
            }
        }
    }
    
    private func getFirstRaceResult() -> RaceResult?{
        if let rr = raceResults?.allObjects as? [RaceResult]{
            if rr.count > 0 { return rr[0]}
        }
        return nil
    }
    
    
}
