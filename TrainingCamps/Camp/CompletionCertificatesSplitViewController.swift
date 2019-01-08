//
//  CompletionCertificatesSplitViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 03/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CompletionCertificatesSplitViewController: NSSplitViewController, CampViewControllerProtocol, CampParticipantViewControllerProtocol{
    
    func getCerticate() -> NSView?{
        for c in children{
            if let vc = c as? CampCompletionCertificationViewController{
                return vc.certificateView
            }
        }
        return nil
    }
    
    func setCamp(_ camp: Camp) {
        for c in children{
            if let vc = c as? CampViewControllerProtocol{
                vc.setCamp(camp)
            }
        }
    }
    
    func setCampParticipant(_ campParticipant: CampParticipant) {
        for c in children{
            if let vc = c as? CampParticipantViewControllerProtocol{
                vc.setCampParticipant(campParticipant)
            }
        }
    }

    
}
