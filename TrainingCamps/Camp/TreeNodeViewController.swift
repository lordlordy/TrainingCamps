//
//  TreeNodeViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 14/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa
import Quartz

class TreeNodeViewController: NSViewController, TreeGeneratorViewControllerProtocol, NSComboBoxDataSource{
   
    func setGenerator(_ treeNodeGenerator: TreeNodeGenerator) {
        generator = treeNodeGenerator
        updateTree()
    }

    @objc dynamic var treeNodes: [TreeNode]?
    @IBOutlet weak var treeView: NSOutlineView!
    @IBOutlet var treeController: NSTreeController!
    @IBOutlet weak var meanOrSumCB: NSComboBox!
    @IBOutlet weak var filterComboBox: ParticipantFilterComboBox!
    
    @IBAction func saveAsPDF(_ sender: Any) {
        let data = treeView.dataWithPDF(inside: treeView.bounds)
        //        let data = mainView.dataWithPDF(inside: mainView.bounds)
        let dialogue = OpenAndSaveDialogues()
        
        let pdf = PDFDocument.init(data: data)
        
        
        if let url = dialogue.saveFilePath(suggestedFileName: "Saved", allowFileTypes: ["pdf"]){
            pdf?.write(to: url)
        }
        
    }
    
    @IBAction func saveAsCSV(_ sender: Any) {

        let csvString: String = CSVExporter().createCSV(forTree: treeNodes ?? [], TreeNodeProperty.CSV.map({$0.rawValue}))
            
            if let url = OpenAndSaveDialogues().saveFilePath(suggestedFileName: "Saved", allowFileTypes: ["csv"]){
                do{
                     try csvString.write(to: url, atomically: false, encoding: .utf8)
                }catch let error as NSError{
                    print(error)
                }
            }

        
        
    }
    
    private var generator: TreeNodeGenerator?
    
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
            print("Tree Order set to: \(treeOrderString). Updating tree...")
            updateTree()
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
    
    //MARK: - NSComboBoxDataSource   participantsOnCampComboBox
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "treeOrderComboBox":
                if let g = generator{
                    let dateStrings = g.treeOrders()
                    if index < dateStrings.count{
                        return dateStrings[index]
                    }
                }
            default:
                print("What combo box is this \(identifier.rawValue) which I'm (TreeNodeViewController) a data source for? ")
            }
        }
        return nil
    }
    
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "treeOrderComboBox":
                return generator?.treeOrders().count ?? 0
            default:
                return 0
            }
        }
        return 0
    }
    

    
    private func updateTree(){
        treeNodes = generator!.generateTree(inOrder: treeOrderString, nodesShow: meanOrSum, participantFilter: filter)
    }
    
    
}
