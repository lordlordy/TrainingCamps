//
//  Rankable.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

@objc protocol Rankable: TrainingValuesProtocol{
    var gender: String { get }
    var name: String { get }
    var campRole: String { get }
    var campName: String { get }
    var rankings: NSSet? { get }
    func rankFor(_ activity: String, _ unit: String) -> Rank
    func performRank()
    
}

