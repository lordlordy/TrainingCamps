//
//  TreeNodeEditable.swift
//  TrainingCamps
//
//  Created by Steven Lord on 25/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

@objc protocol TreeNodeEditable: TreeNode{
    func addChild(_ child: TreeNode)
    func addChildren(_ children: [TreeNode])
    func set(name: String)
}
