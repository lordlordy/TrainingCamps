//
//  TrainingValuesProtocol.swift
//  TrainingCamps
//
//  Created by Steven Lord on 23/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

@objc protocol TrainingValuesProtocol {
    func valueFor(_ activity: String, _ unit: String) ->  Double
}
