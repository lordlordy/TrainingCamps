//
//  Rankable.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

protocol Rankable{
    func valueFor(activity: Activity, unit: Unit, gender: Gender, role: Role, location: Location?, participant: Participant?, camp: Camp?) ->  Double

}
