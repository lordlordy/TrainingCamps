//
//  TreeToggler.swift
//  TrainingCamps
//
//  Created by Steven Lord on 16/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation
//this should not be needed. The Responder Chain should do this ... At come point figure that out. This protocol is currently used so the TreeNodeViewController can move up the responder chain looking for this protocol
protocol TreeToggler{
    func toggleTree()
}
