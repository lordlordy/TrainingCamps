//
//  CampRaceResultViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 20/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampRaceResultViewController: CampViewController, RaceViewControllerProtocol, NSComboBoxDataSource, NSTableViewDelegate{
    
    enum ColumnID: String{
        case swim, t1, bike, t2, run, handicap, adjTotal, guess, guessDiff
        case handicapEstimated, rankAfterHandicap, points
        case swimRank, t1Rank, bikeRank, t2Rank, runRank, rankGuess
        case isRelay, total
    }
    
    @objc dynamic var race: Race?
    @IBOutlet var raceResultsAC: NSArrayController!
    
    @IBOutlet weak var raceResultsTableView: NSTableView!
    
    @IBAction func showAllColumns(_ sender: Any?){
        for col in raceResultsTableView.tableColumns{
            col.isHidden = false
        }
    }
    
    @IBAction func reload(_ sender: Any) {
        raceResultsTableView.reloadData()
    }
    
    @IBAction func saveAsCSV(_ sender: Any) {
        
        let csvString: String = CSVExporter().createCSV(forObjs: raceResultsAC.arrangedObjects as? [NSObject] ?? [], RaceResultProperty.CSV.map({$0.rawValue}))
        
        var suggestedName: String = "RaceResult"
        
        if let results = raceResultsAC?.arrangedObjects as? [RaceResult]{
            if results.count > 0{
                suggestedName = results[0].race?.raceDefinition?.name ?? "RaceResults"
                if let raceDate = results[0].race?.date{
                    let df: DateFormatter = DateFormatter()
                    df.dateFormat = "yyyy-MMM-dd"
                    suggestedName += "-"
                    suggestedName += df.string(from: raceDate)
                }
            }
        }
        
        if let url = OpenAndSaveDialogues().saveFilePath(suggestedFileName: suggestedName, allowFileTypes: ["csv"]){
            do{
                try csvString.write(to: url, atomically: false, encoding: .utf8)
            }catch let error as NSError{
                print(error)
            }
        }
        
    }
    

    
    func setRace(_ race: Race) {
        self.race = race
        updateColumns()
    }
    
    //MARK: - NSComboBoxDataSource
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        if let displayNames: [String] = race?.camp?.campParticipantDisplayNames(){
            if index < displayNames.count{
                return displayNames[index]
            }
        }
        return nil
    }
    
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return camp?.campParticipantDisplayNames().count ?? 0
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let selection = raceResultsAC.selectedObjects as? [RaceResult]{
            if selection.count > 0{
                if let p = parent as? RankingsViewControllerProtocol{
                    p.setRankings(selection[0])
                }
            }
        }
    }
    
    private func updateColumns(){
        let disciplineCount: Int = race?.raceDefinition?.disciplineCount ?? 0
        
        for col in raceResultsTableView.tableColumns{
            switch col.identifier.rawValue{
            case ColumnID.swim.rawValue:
                col.isHidden = !(race?.includesSwim ?? true)
            case ColumnID.swimRank.rawValue:
                col.isHidden = (disciplineCount == 1) || !(race?.includesSwim ?? true)
            case ColumnID.bike.rawValue:
                col.isHidden = !(race?.includesBike ?? true)
            case ColumnID.bikeRank.rawValue:
                col.isHidden = (disciplineCount == 1) || !(race?.includesBike ?? true)
            case ColumnID.t2.rawValue, ColumnID.t2Rank.rawValue:
                col.isHidden = disciplineCount < 3
            case ColumnID.run.rawValue:
                col.isHidden = !(race?.includesRun ?? true)
            case ColumnID.runRank.rawValue:
                col.isHidden = (disciplineCount == 1) || !(race?.includesRun ?? true)
            case ColumnID.handicap.rawValue, ColumnID.handicapEstimated.rawValue, ColumnID.rankAfterHandicap.rawValue, ColumnID.adjTotal.rawValue:
                col.isHidden = !(race?.isHandicap ?? true)
            case ColumnID.guess.rawValue, ColumnID.guessDiff.rawValue, ColumnID.rankGuess.rawValue:
                col.isHidden = !(race?.isGuessYourTime ?? true)
            case ColumnID.points.rawValue:
                col.isHidden = !(race?.isForCampPoints ?? true)
            case ColumnID.total.rawValue, ColumnID.isRelay.rawValue, ColumnID.t1.rawValue, ColumnID.t1Rank.rawValue:
                col.isHidden = disciplineCount == 1
            default:
                col.isHidden = false
            }
        }
    }
    
    
}
