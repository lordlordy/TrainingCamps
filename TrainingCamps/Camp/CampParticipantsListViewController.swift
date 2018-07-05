//
//  CampParticipantsListViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 17/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa
import Quartz

class CampParticipantsListViewController: CampViewController, NSComboBoxDataSource, NSTableViewDelegate{
  
    
    @IBOutlet var campParticipantAC: NSArrayController!
    
    @IBOutlet weak var pointsTable: NSTableView!
    
    
    @IBAction func rankCompetition(_ sender: Any){
        if let c = camp{
            c.rankCompetition()
        }
    }
    
    @IBAction func saveAsPDF(_ sender: Any) {
        var headers = pointsTable.headerView?.dataWithPDF(inside: (pointsTable.headerView?.bounds)!)
        let rows = pointsTable.dataWithPDF(inside: pointsTable.bounds)
        
//        let rect = NSRect(x: 0, y: -0.23, width: 1489, height: 365  )
//        let rows = pointsTable.dataWithPDF(inside: rect)

        
//        if var data = headers{
            headers!.append(rows)
            let pdf = PDFDocument.init(data: headers!)
            
            
            if let url = OpenAndSaveDialogues().saveFilePath(suggestedFileName: "CampPoints", allowFileTypes: ["pdf"]){
                pdf?.write(to: url)
            }
//        }
    }
    
    @IBAction func saveAsCSV(_ sender: Any) {
        
        let csvString: String = CSVExporter().createCSV(forObjs: campParticipantAC.arrangedObjects as? [NSObject] ?? [], CampParticipantProperty.CSV.map({$0.rawValue}))
        
        if let url = OpenAndSaveDialogues().saveFilePath(suggestedFileName: "PointsTable", allowFileTypes: ["csv"]){
            do{
                try csvString.write(to: url, atomically: false, encoding: .utf8)
            }catch let error as NSError{
                print(error)
            }
        }
        
    }

    //MARK: - NSTableViewDelegate
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let cp = getSelectedParticipant(){
            if let vc = parent?.parent as? RaceResultsViewControllerProtocol{
                vc.setRaceResults(cp.raceResults ?? NSSet())
            }
            if let vc = parent?.parent as? CampParticipantViewControllerProtocol{
                vc.setCampParticipant(cp)
            }
            if let vc = parent as? RankingsViewControllerProtocol{
                vc.setRankings(cp)
            }
        }
    }

    @IBAction func selectedParticipant(_ sender: NSComboBox) {
        let name: String = sender.stringValue
        if let c = camp{
            if c.isOnCamp(displayName: name){
                campParticipantAC.filterPredicate = NSPredicate(format: "participant.displayName CONTAINS %@", argumentArray: [name])
                campParticipantAC.setSelectionIndex(0)
            }else{
                campParticipantAC.filterPredicate = nil
                sender.stringValue = ""
            }
        }
    }
    
    //MARK: - NSComboBoxDataSource   participantsOnCampComboBox
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "CampParticipantComboBox":
                let participants = getParticipantsNotYetIncludedInCamp()
                if index < participants.count{
                    return participants[index]
                }
            case "participantsOnCampComboBox":
                let participants = camp?.campParticipantDisplayNames() ?? []
                if index < participants.count{
                    return participants[index]
                }
            default:
                print("What combo box is this \(identifier.rawValue) which I'm (CampParticipantsListViewController) a data source for? ")
            }
        }
        return nil
    }
    
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "CampParticipantComboBox":
                return getParticipantsNotYetIncludedInCamp().count
            case "participantsOnCampComboBox":
                return camp?.campParticipantUniqueNames().count ?? 0
            default:
                return 0
            }
        }
        return 0
    }
    
    private func getParticipantsNotYetIncludedInCamp() -> [String]{
        var result: [String] = []
        if let a = camp{
            if let cg = a.campGroup{
                let allP = cg.participantArray().map({$0.displayName})
                let campP = a.campParticipantsArray().map({$0.participant?.displayName ?? "Not set"})
                for p in allP{
                    if !campP.contains(p){
                        result.append(p)
                    }
                }
            }
        }
        return result.sorted(by: {$0 < $1})
    }
    
    private func getSelectedParticipant() -> CampParticipant?{
        if let selection = campParticipantAC.selectedObjects as? [CampParticipant]{
            if selection.count > 0{
                return selection[0]
            }
        }
        return nil
    }
    
}
