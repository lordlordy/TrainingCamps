//
//  ViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class ViewController: NSSplitViewController, CampGroupViewControllerProtocol {

    @objc dynamic var managedObjectContext: NSManagedObjectContext

    
    
    required init?(coder: NSCoder) {
        
        self.managedObjectContext = CoreDataStack.shared.trainingCampsPC.viewContext
        super.init(coder: coder)
        
        ValueTransformer.setValueTransformer(TransformerNSNumberToTimeFormat(), forName: NSValueTransformerName(rawValue: "TransformerNSNumberToTimeFormat"))
        
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
    
/*    func setCamp(_ camp: Camp) {
        for c in childViewControllers{
            if let cvcp = c as? CampViewControllerProtocol{
                cvcp.setCamp(camp)
            }
        }
        if let w = view.window{
            w.title = camp.campName ?? "Unkown Camp"
        }
    }
    */
    func setCampGroup(_ campGroup: CampGroup) {
        for c in childViewControllers{
            if let cgvcp = c as? CampGroupViewControllerProtocol{
                cgvcp.setCampGroup(campGroup)
            }
        }
    }

}

