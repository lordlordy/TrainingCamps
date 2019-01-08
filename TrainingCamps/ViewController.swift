//
//  ViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa
import Quartz

class ViewController: NSSplitViewController, CampGroupViewControllerProtocol {

    @objc dynamic var managedObjectContext: NSManagedObjectContext

    @objc dynamic var swimColour: NSColor = NSColor.blue
    @IBOutlet weak var mainView: NSSplitView!
    
    required init?(coder: NSCoder) {
        
        self.managedObjectContext = CoreDataStack.shared.trainingCampsPC.viewContext
        super.init(coder: coder)
        
        ValueTransformer.setValueTransformer(TransformerNSNumberToTimeFormat(), forName: NSValueTransformerName(rawValue: "TransformerNSNumberToTimeFormat"))
        ValueTransformer.setValueTransformer(TextViewToStringTransformer(), forName: NSValueTransformerName(rawValue: "TextViewToStringTransformer"))
        
    }
    
    @IBAction func saveScreenAsPDF(_ sender: Any){
        let data = mainView.dataWithPDF(inside: mainView.visibleRect)
        let dialogue = OpenAndSaveDialogues()
        
        let pdf = PDFDocument.init(data: data)
        
        
        if let url = dialogue.saveFilePath(suggestedFileName: "Camps", allowFileTypes: ["pdf"]){
            pdf?.write(to: url)
        }
    }
    

    
    @IBAction func newCampGroup(_ sender: Any){
        let _ = CoreDataStack.shared.newCampGroup()
    }
    
    @IBAction func importFromFile(_ sender: Any){
        if let url = OpenAndSaveDialogues().selectedPath(withTitle: "chose .json file",andFileTypes: ["json"]) {
            JSONImporter().importCampGroup(fromURL: url)
            print(url)
           
        }
    }
    
    func setCampGroup(_ campGroup: CampGroup) {
        for c in children{
            if let cgvcp = c as? CampGroupViewControllerProtocol{
                cgvcp.setCampGroup(campGroup)
            }
        }
    }

}

