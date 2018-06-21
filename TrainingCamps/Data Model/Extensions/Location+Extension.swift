//
//  Location+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 13/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension Location{
    
    @objc dynamic var campCount: Int{ return camps?.count ?? 0}
    @objc dynamic var noCamps: Bool { return campCount == 0}
    
}
