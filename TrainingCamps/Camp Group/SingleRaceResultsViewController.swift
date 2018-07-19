//
//  SingleRaceResultsViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class SingleRaceResultsViewController: NSViewController, RaceResultsViewControllerProtocol, RaceViewControllerProtocol, NSComboBoxDataSource, NSTableViewDelegate{

    
    
    enum ColumnID: String{
        case swim, t1, bike, t2, run, handicap, adjTotal, guess, guessDiff
        case handicapEstimated, rankAfterHandicap, points
        case swimRank, t1Rank, bikeRank, t2Rank, runRank, rankGuess
        case isRelay, total
    }
    
    @IBOutlet weak var campCB: NSComboBox!
    @IBOutlet weak var genderCB: GenderComboBox!
    @IBOutlet weak var participantCB: NSComboBox!
    @IBOutlet weak var roleCB: NSComboBox!
    
    
    @objc dynamic var raceResults: NSSet?
    @objc dynamic var race: Race?
    @objc dynamic var raceName: String?

    
    @objc dynamic var resultsEditable: Bool {
        return race != nil
        
    }
    
    @IBOutlet weak var raceResultsTableView: NSTableView!
    @IBOutlet var resultsAC: NSArrayController!
    
    private var stdFilterPredicateString: String = "raceCompletionStatus == 'Y'"
    
    @IBAction func showAllColumns(_ sender: Any?){
        for col in raceResultsTableView.tableColumns{
            col.isHidden = false
        }
    }
    
    @IBAction func filterChanged(_sender: Any?){
        updatePredicate()
    }
    
    @IBAction func saveAsCSV(_ sender: Any) {
        
        let csvString: String = CSVExporter().createCSV(forObjs: raceResults?.allObjects as? [NSObject] ?? [], RaceResultProperty.CSV.map({$0.rawValue}))
        
        var suggestedName: String = "RaceResult"
        
        if let results = raceResults?.allObjects as? [RaceResult]{
            if results.count > 0{
                suggestedName = results[0].race?.raceDefinition?.name ?? "RaceResults"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsAC.filterPredicate = NSPredicate(format: stdFilterPredicateString, argumentArray: nil)
    }
    
    
    func setRace(_ race: Race) {
        self.race = race
        raceResults = race.mutableSetValue(forKey: RaceProperty.results.rawValue)
        raceName = race.name
        updateColumns()
    }
    
    func setRaceResults(_ raceResults: NSSet) {
        self.raceResults = raceResults
        if let r = getFirstRaceResult(){
            raceName = r.race?.name ?? "No Name"
        }
        updateColumns()
    }
    
    //MARK: - NSComboBoxDataSource
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        if let rr = getFirstRaceResult(){
            if let identifier = comboBox.identifier{
                switch identifier.rawValue{
                case "campCB":
                    if let campNames: [String] = rr.race?.raceDefinition?.campGroup?.campsArray().map({$0.campName ?? "Not set"}){
                        if index < campNames.count{
                            return campNames[index]
                        }
                    }
                case "participantCB":
                    if let displayNames: [String] = rr.race?.raceDefinition?.campGroup?.participantArray().map({$0.displayName}){
                        if index < displayNames.count{
                            return displayNames[index]
                        }
                    }
                default:
                    print("What combo box is this \(identifier.rawValue) which I'm (CampRacesViewController) a data source for? ")
                }
            }
        }

        
        return nil
        
    }
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        if let rr = getFirstRaceResult(){
            if let identifier = comboBox.identifier{
                switch identifier.rawValue{
                case "campCB":
                    return rr.race?.raceDefinition?.campGroup?.camps?.count ?? 0
                case "participantCB":
                    return rr.race?.raceDefinition?.campGroup?.participants?.count ?? 0
                default: return 0
                }
            }
        }
        return 0
    }
    
    //MARK: - NSTableViewDelegate
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let p = parent as? RaceResultsDistributionSplitViewController{
            if let selection = resultsAC.selectedObjects as? [RaceResult]{
                    p.setHighlightedValue(selection.map({$0.totalSeconds}))
            }
        }
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
    
    
    
    
    private func updatePredicate(){
        var predicateString: String = ""
        var arguments: [Any] = []
        var isFirstPredicate = true
        if campCB.stringValue != ""{
            predicateString = addTo(predicateString: predicateString, withPredicateString: "race.camp.campName CONTAINS %@", isFirstPredicate)
            arguments.append(campCB.stringValue)
            isFirstPredicate = false
        }
        if genderCB.stringValue != ""{
            predicateString = addTo(predicateString: predicateString, withPredicateString: " campParticipant.participant.gender CONTAINS %@", isFirstPredicate)
            arguments.append(genderCB.stringValue)
            isFirstPredicate = false
        }
        if participantCB.stringValue != ""{
            predicateString = addTo(predicateString: predicateString, withPredicateString: " campParticipant.participant.displayName CONTAINS %@", isFirstPredicate)
            arguments.append(participantCB.stringValue)
            isFirstPredicate = false
        }
        if roleCB.stringValue != ""{
            predicateString = addTo(predicateString: predicateString, withPredicateString: "campParticipant.role CONTAINS %@", isFirstPredicate)
            arguments.append(roleCB.stringValue)
            isFirstPredicate = false
        }
        
        if predicateString == "" {
            resultsAC.filterPredicate = NSPredicate(format: stdFilterPredicateString, argumentArray: nil)
        }else{
            predicateString = addTo(predicateString: predicateString, withPredicateString: stdFilterPredicateString, isFirstPredicate)
            resultsAC.filterPredicate = NSPredicate.init(format: predicateString, argumentArray: arguments)
        }

        
        
    }
    
    private func addTo(predicateString: String, withPredicateString: String,_ isFirstPredicate: Bool) -> String{
        if isFirstPredicate{
            return withPredicateString
        }else{
            return predicateString + " AND " + withPredicateString
        }
    }
    
    
}
