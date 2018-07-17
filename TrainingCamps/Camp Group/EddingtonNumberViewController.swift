//
//  EddingtonNumberViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 28/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa
import Quartz

class EddingtonNumberViewController: CampGroupViewController, NSComboBoxDataSource{
    
    @IBOutlet var eddingtonNumberAC: NSArrayController!
    @IBOutlet weak var tableScrollView: NSScrollView!
    
    @IBAction func calculateSelection(_ sender: Any) {
        if let selection = eddingtonNumberAC.selectedObjects as? [EddingtonNumber]{
            for s in selection{
                s.calculate()
            }
        }
    }
    
    @IBAction func saveVisibleTableAsPDF(_ sender: Any){
        let data = tableScrollView.dataWithPDF(inside: tableScrollView.bounds)
        let pdf = PDFDocument.init(data:data)
        
        if let url = OpenAndSaveDialogues().saveFilePath(suggestedFileName: "EddingtonNumbers", allowFileTypes: ["pdf"]){
            pdf?.write(to: url)
        }
    }
    
    
    @IBAction func saveAsCSV(_ sender: Any) {
        
        let csvString: String = CSVExporter().createCSV(forObjs: eddingtonNumberAC.arrangedObjects as? [NSObject] ?? [], EddingtonNumberProperty.CSV.map({$0.rawValue}))
        
        if let url = OpenAndSaveDialogues().saveFilePath(suggestedFileName: "EddingtonNumbers", allowFileTypes: ["csv"]){
            do{
                try csvString.write(to: url, atomically: false, encoding: .utf8)
            }catch let error as NSError{
                print(error)
            }
        }
        
    }
    
    //MARK: - NSComboBoxDataSource   participantsOnCampComboBox
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "activityComboBox":
                let strings: [String] = Activity.Eddington.map({$0.rawValue}).sorted()
                if index < strings.count{
                    return strings[index]
                }
            case "unitComboBox":
                let strings: [String] = Unit.Eddington.map({$0.rawValue}).sorted()
                if index < strings.count{
                    return strings[index]
                }
            default:
                print("What combo box is this \(identifier.rawValue) which I'm (EddingtonNumberViewController) a data source for? ")
            }
        }
        return nil
    }
    
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "activityComboBox":
                return Activity.Eddington.count
            case "unitComboBox":
                return Unit.Eddington.count
            default:
                return 0
            }
        }
        return 0
    }
    
}
