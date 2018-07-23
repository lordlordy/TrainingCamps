//
//  TrainingDataProtocol.swift
//  TrainingCamps
//
//  Created by Steven Lord on 19/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation


@objc protocol TrainingDataProtocol: NSObjectProtocol {

    @objc var date:                 Date? {get}
    @objc var swimKM:               Double {get}
    @objc var bikeKM:               Double {get}
    @objc var runKM:                Double {get}
    @objc var totalSeconds:         Double {get}
    
    @objc var role:                 String? {get}
    @objc var campName:             String {get}
    @objc var participantName:      String {get}
    @objc var gender:               String {get}
    @objc var campType:             String {get}
    
    @objc var campComplete:          Bool {get}
    
    func value(forKey key: String) -> Any?
    
    
}
