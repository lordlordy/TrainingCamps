//
//  CampCompletionListViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 03/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa
import Quartz

class CampCompletionListViewController: NSViewController, CampViewControllerProtocol, NSTableViewDelegate{
    
    @objc dynamic var camp: Camp?
    @IBOutlet var campParticipantsAC: NSArrayController!
    
    @IBAction func saveCertificate(_ sender: Any) {
        
        if let p = parent as? CompletionCertificatesSplitViewController{
            if let certificateView = p.getCerticate(){
                let dialogue = OpenAndSaveDialogues()
                
                let data = certificateView.dataWithPDF(inside: certificateView.visibleRect)
                let pdf = PDFDocument.init(data: data)
                
                if let url = dialogue.saveFilePath(suggestedFileName: "Certificate", allowFileTypes: ["pdf"]){
                    pdf?.write(to: url)
                }
            }
        }
    }
    
    func setCamp(_ camp: Camp) {
        self.camp = camp
    }
    
    
    //MARK: - NSTableViewDelegate
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let p = parent as? CampParticipantViewControllerProtocol{
            if let cp = selectedParticipant(){
                p.setCampParticipant(cp)
            }
        }
    }
    
    private func selectedParticipant() -> CampParticipant?{
        if let ac = campParticipantsAC{
            if let selection = ac.selectedObjects as? [CampParticipant]{
                if selection.count > 0{
                    return selection[0]
                }
            }
        }
        return nil
    }
}
