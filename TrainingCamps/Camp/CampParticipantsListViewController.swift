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
    
    @IBOutlet weak var tableScrollView: NSScrollView!
    @IBOutlet weak var pointsTable: NSTableView!
    @IBOutlet weak var clipView: NSClipView!
    
    
    @IBAction func rankCompetition(_ sender: Any){
        if let c = camp{
            c.rankCompetition()
        }
    }
    
    @IBAction func saveVisibleTableAsPDF(_ sender: Any){
        let data = tableScrollView.dataWithPDF(inside: tableScrollView.frame)
        let pdf = PDFDocument.init(data:data)
        
        if let url = OpenAndSaveDialogues().saveFilePath(suggestedFileName: "CampPoints", allowFileTypes: ["pdf"]){
            pdf?.write(to: url)
        }
    }
    
    @IBAction func saveAsPDF(_ sender: Any) {
        
        let printView: NSView = NSView.init(frame: NSRect.init(x: 0.0, y: 0.0, width: pointsTable.bounds.width, height:  pointsTable.bounds.height + (pointsTable.headerView?.bounds.height)!))
        
        let headerV: NSView = pointsTable.headerView!
        
        let originalFram = headerV.frame
        
        print("Views in the clipView")
        for v in clipView.subviews{
            print(v)
        }
        
        headerV.frame = NSRect(x: 0.0, y: pointsTable.bounds.height, width: headerV.bounds.width, height: headerV.bounds.height)
        printView.addSubview(pointsTable)
        printView.addSubview(headerV)


        print("Views in the clipView")
        for v in clipView.subviews{
            print(v)
        }
        
        

//        var testData = pointsTable.dataWithPDF(inside: pointsTable.bounds)
//        var compare: [(UInt8, UInt8)] = []
//        var i: Int = 0
//        test: for h in testData{
//            compare.append((h,0))
//            i += 1
//        }
//
//        testData.append(headerV.dataWithPDF(inside: headerV.bounds))
//
//        var j: Int = 0
//        test: for h in testData{
//            if compare.count > j{
//                compare[j].1 = h
//            }else{
//                compare.append((0,h))
//            }
//            j += 1
//            if j>=i + 10 { break test }
//        }
//
//        for c in compare{
//            print(c)
//        }
        
        printView.translatesAutoresizingMaskIntoConstraints = false
        headerV.translatesAutoresizingMaskIntoConstraints = false
        pointsTable.translatesAutoresizingMaskIntoConstraints = false
        
        let data = printView.dataWithPDF(inside: printView.bounds)
        let pdf = PDFDocument.init(data:data)
        
        if let url = OpenAndSaveDialogues().saveFilePath(suggestedFileName: "CampPoints", allowFileTypes: ["pdf"]){
            pdf?.write(to: url)
        }
        
        clipView.addSubview(pointsTable)
        
        print("Views in the clipView")
        for v in clipView.subviews{
            print(v)
        }
        
        
        pointsTable.translatesAutoresizingMaskIntoConstraints = true
        headerV.frame = originalFram
        pointsTable.reloadData()
        pointsTable.needsDisplay = true

        
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
