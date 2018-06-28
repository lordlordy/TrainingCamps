//
//  TreeNodeViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 14/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa
class TreeNodeViewController: NSViewController, CampGroupViewControllerProtocol{
    
    @objc dynamic var treeNodes: [TreeNode]?
    @IBOutlet weak var treeView: NSOutlineView!
    @IBOutlet var treeController: NSTreeController!
    @IBOutlet weak var meanOrSumCB: NSComboBox!
    @IBOutlet weak var filterComboBox: ParticipantFilterComboBox!
    
    
    private var campGroup: CampGroup?
    private var camps: [Camp]?
    private var treeGenerate: TreeGenerator = TreeGenerator()
    private var treeOrder: TreeGenerator.TreeOrder = TreeGenerator.TreeOrder.standard
    private var meanOrSum: Maths.Aggregator = Maths.Aggregator.Sum
    private var filter: ParticipantFilter = ParticipantFilter.All
    

    @objc dynamic var filterString: String{
        didSet{
            if let f = ParticipantFilter(rawValue:filterString){
                filter = f
            }else{
                filter = ParticipantFilter.All
                filterString = filter.rawValue
                filterComboBox.stringValue = filterString
            }
            updateTree()
        }
    }
    
    @objc dynamic var meanOrSumString: String{
        didSet{
            if let m = Maths.Aggregator(rawValue: meanOrSumString){
                meanOrSum = m
            }else{
                meanOrSum = Maths.Aggregator.Sum
                meanOrSumString = Maths.Aggregator.Sum.rawValue
                meanOrSumCB.stringValue = meanOrSumString
            }
            updateTree()
        }
    }
    
    @objc dynamic var treeOrderString: String = TreeGenerator.TreeOrder.standard.rawValue{
        didSet{
            if let to = TreeGenerator.TreeOrder(rawValue: treeOrderString){
                treeOrder = to
                print("Tree Order set to: \(to). Updating tree...")
                updateTree()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        meanOrSumString = Maths.Aggregator.Sum.rawValue
        filterString = ParticipantFilter.All.rawValue
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meanOrSumCB.stringValue = Maths.Aggregator.Sum.rawValue
    }
    
    func setCamps(_ camps: [Camp]?){
        self.camps = camps
        updateTree()
    }

    func setCampGroup(_ campGroup: CampGroup) {
        self.campGroup = campGroup
        updateTree()
    }
    
    private func updateTree(){
        if let cg = campGroup{
            treeNodes = treeGenerate.generateTree(forGroup: cg, forCamps: camps, andOrder: treeOrder, nodesShow: meanOrSum, participantFilter: filter)
        }
    }
    
    
}
