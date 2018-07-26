//
//  TrainingDistributionViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 19/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class TrainingDistributionViewController: NSViewController, CampGroupViewControllerProtocol, NSComboBoxDataSource, NormalDistributionViewControllerProtocol{

    
    
    private var campGroup: CampGroup?
    private var hourMinuteFormatter: (Double) -> String = { // this is hours:minutes - so no seconds
        let s: Int = Int($0)
        let mins = (abs(s) / 60) % 60
        let hours = (abs(s) / 3600)
        return String(format: "%02d:%02d", hours, mins)
    }
    private var completerFilters: [DistributionSelection]?
    private var genderFilters: [DistributionSelection]?
    private var roleFilters: [DistributionSelection]?
    private var campTypeFilters: [DistributionSelection]?
    
    @IBOutlet weak var campDayCB: NSComboBox!
    @IBOutlet weak var propertyCB: NSComboBox!
    @IBOutlet weak var participantCB: NSComboBox!
    
    @IBAction func propertyCBChanged(_ sender: Any) {
        updateGraph()
    }
    
    @IBAction func participantCBChanged(_ sender: Any) {
        if let dv = getTrainingDataViewController(){
            dv.filter(forParticipant: participantCB.stringValue)
        }
    }
    
    @IBAction func campDayCBChange(_ sender: Any) {
        updateGraph()
    }
    
    func setCampGroup(_ campGroup: CampGroup) {
        self.campGroup = campGroup
        campDayCBChange(self)
        for c in childViewControllers{
            if let vc = c as? CampGroupViewControllerProtocol{
                vc.setCampGroup(campGroup)
            }
        }
    }
    
    func set(selection: [TrainingDataProtocol]){
        if let graph = getGraphView(){
            if let property = TrainingDataProtocolProperty(rawValue: propertyCB.stringValue){
                let doubles = selection.map({$0.value(forKey: property.rawValue) as! Double})
                graph.setHighlighted(x: doubles)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        campDayCB.stringValue = "Camp"
        propertyCB.stringValue = TrainingDataProtocolProperty.totalSeconds.rawValue
    }
    
    //MARK: - NSComboBoxDataSource   participantsOnCampComboBox
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "PropertyCB":
                let strings: [String] = TrainingDataProtocolProperty.distributable.map({$0.rawValue})
                if index < strings.count{
                    return strings[index]
                }
            case "ParticipantCB":
                let displayNames: [String] = campGroup?.participantArray().map({$0.displayName}) ?? []
                if index < displayNames.count{
                    return displayNames[index]
                }
            default:
                print("What combo box is this \(identifier.rawValue) which I'm (TrainingDistributionViewController) a data source for? ")
            }
        }
        return nil
    }
    
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        if let identifier = comboBox.identifier{
            switch identifier.rawValue{
            case "PropertyCB":
                return TrainingDataProtocolProperty.distributable.count
            case "ParticipantCB":
                return campGroup?.participantArray().count ?? 1
            default:
                return 0
            }
        }
        return 0
    }
    
    func updateBuckets(forSelection selection: [DistributionSelection]) {
        
        let completer: [DistributionSelection] = selection.filter({$0.isCompletion})
        let gender: [DistributionSelection] = selection.filter({$0.isGender})
        let role: [DistributionSelection] = selection.filter({$0.isRole})
        let campType: [DistributionSelection] = selection.filter({$0.isCampType})
        
        if completer.reduce(true, {$0 && $1.include}){
            // all true so set fitlers to nil
            completerFilters = nil
        }else{
            completerFilters = completer
        }

        if gender.reduce(true, {$0 && $1.include}){
            genderFilters = nil
        }else{
            genderFilters = gender
        }

        if role.reduce(true, {$0 && $1.include}){
            roleFilters = nil
        }else{
            roleFilters = role
        }

        if campType.reduce(true, {$0 && $1.include}){
            campTypeFilters = nil
        }else{
            campTypeFilters = campType
        }
        updateGraph()
    }
    
    private func updateGraph(){
        if let cg = campGroup{
            if let vc = getTrainingDataViewController(){
                if let property = TrainingDataProtocolProperty(rawValue: propertyCB.stringValue){
                    if campDayCB.stringValue == "Day"{
                        vc.data = cg.participantDaysArray().filter({$0.value(forKey: property.rawValue) as! Double > 0.0})
                    }else{
                        vc.data = cg.campParticipantsArray().filter({$0.value(forKey: property.rawValue) as! Double > 0.0})
                    }
                    let data = filter(data: vc.data)
                    let bucketGenerator = getBucketGenerator(forProperty: property)
                    let buckets = bucketGenerator.createBuckets(forDoubleProperty: property, data: data)
                    let stdDevMean = Maths().stdDevMeanTotal(data.map({$0.value(forKey: property.rawValue) as! Double}))
                    let logStdDevMean = Maths().stdDevMeanTotal(data.map({log($0.value(forKey: property.rawValue) as! Double)}))
                    if let dg = getGraphView(){
                        dg.set(buckets: buckets, mean: stdDevMean.mean , variance: pow(stdDevMean.stdDev,2))
                        dg.setLogNormal(meanOfLogs: logStdDevMean.mean, stdDevOfLogs: logStdDevMean.stdDev)
                        dg.xAxisFormatter = getXAxisFormatter(forProperty: property)
                        
                    }
                    if let bv = getBucketView(fromVCs: childViewControllers){
                        bv.buckets = buckets.filter({$0.size > 0.0})
                    }

                }
            }
        }
    }
    
    private func filter(data: [TrainingDataProtocol]) -> [TrainingDataProtocol]{
        var result: [TrainingDataProtocol] = data
        if completerFilters != nil{
            //filter on completers
            result = result.filter(filterCompleters)
        }
        if genderFilters != nil{
            result = result.filter(filterGenders)
        }
        if roleFilters != nil{
            result = result.filter(filterRoles)
        }
        if campTypeFilters != nil{
            result = result.filter(filterCampTypes)
        }

        return result
    }
    
    private func filterCompleters(tdp: TrainingDataProtocol) -> Bool{
        for i in completerFilters ?? []{
            if i.name == DistributionSelectionTypes.Completers.rawValue{
                if i.include{
                    //include completers
                    return tdp.campComplete
                }
            }else if i.name == DistributionSelectionTypes.NonCompleters.rawValue{
                if i.include{
                    //include  Non Completers
                    return !tdp.campComplete
                }
            }
        }
        return false
    }
    
    private func filterGenders(tdp: TrainingDataProtocol) -> Bool{
        var result = false
        for i in genderFilters ?? []{
            if tdp.gender == i.name{
                result = result || i.include
            }
        }
        return result
    }

    private func filterRoles(tdp: TrainingDataProtocol) -> Bool{
        var result = false
        for i in roleFilters ?? []{
            if tdp.role! == i.name{
                result = result || i.include
            }
        }
        return result
    }

    private func filterCampTypes(tdp: TrainingDataProtocol) -> Bool{
        var result = false
        for i in campTypeFilters ?? []{
            if tdp.campType == i.name{
                result = result || i.include
            }
        }
        return result
    }
    
    private func getXAxisFormatter(forProperty p: TrainingDataProtocolProperty) -> ((Double) -> String){
        switch p{
        case .totalSeconds:
            return hourMinuteFormatter
        case .bikeKM:
            return {
                let formatter: NumberFormatter = NumberFormatter()
                formatter.format = "#,##0"
                var result: String = formatter.string(for: $0)!
                result += "km"
                return result
            }
        case .swimKM, .runKM:
            return {
            let formatter: NumberFormatter = NumberFormatter()
            formatter.format = "#,##0.0"
            var result: String = formatter.string(for: $0)!
            result += "km"
            return result
            }
        }
    }
    
    private func getBucketGenerator(forProperty p: TrainingDataProtocolProperty) -> BucketGenerator{

        switch p{
        case .totalSeconds:
            let bg = FixedWidthBucketGenerator(startingAt: 0.0, width: 15.0 * 60.0)
            if campDayCB.stringValue == "Camp"{
                bg.bucketWidth = 60.0 * 60.0
            }
            bg.nameGenerator = {
                var result: String = self.hourMinuteFormatter($0.from)
                result += " to "
                result += self.hourMinuteFormatter($0.to)
                return result
            }
            return bg
        case .swimKM:
            let bg = FixedWidthBucketGenerator(startingAt: 0.0, width: 0.25)
            if campDayCB.stringValue == "Camp"{
                bg.bucketWidth = 1.0
            }
            bg.nameGenerator = {
                let formatter: NumberFormatter = NumberFormatter()
                formatter.format = "#,##0.00"
                var result: String = formatter.string(for: $0.from)!
                result += "km to "
                result += formatter.string(for: $0.to)!
                result += "km"
                return result
            }
            return bg
        case .bikeKM:
            let bg = FixedWidthBucketGenerator(startingAt: 0.0, width: 10.0)
            if campDayCB.stringValue == "Camp"{
                bg.bucketWidth = 25.0
            }
            bg.nameGenerator = {
                let formatter: NumberFormatter = NumberFormatter()
                formatter.format = "#,##0"
                var result: String = formatter.string(for: $0.from)!
                result += "km to "
                result += formatter.string(for: $0.to)!
                result += "km"
                return result
            }
            return bg
        case .runKM:
            let bg = FixedWidthBucketGenerator(startingAt: 0.0, width: 1.0)
            if campDayCB.stringValue == "Camp"{
                bg.bucketWidth = 5.0
            }
            bg.nameGenerator = {
                let formatter: NumberFormatter = NumberFormatter()
                formatter.format = "#,##0.0"
                var result: String = formatter.string(for: $0.from)!
                result += "km to "
                result += formatter.string(for: $0.to)!
                result += "km"
                return result
            }
            return bg

            
        }
        
    }
    
    
    private func getTrainingDataViewController() -> TrainingDataViewController?{
        for child in childViewControllers{
            if let vc = child as? TrainingDataViewController{
                return vc
            }else{
                for c in child.childViewControllers{
                    if let vc = c as? TrainingDataViewController{
                        return vc
                    }else{
                        for grandChild in c.childViewControllers{
                            if let vc = grandChild as? TrainingDataViewController{
                                return vc
                            }
                        }
                    }
                }
            }
        }
        return nil
    }
    
    private func getGraphView() -> DistributionGraph?{
        for child in childViewControllers{
            if let vc = child as? TrainingDistributionGraphViewController{
                return vc.graphView
            }else{
                for c in child.childViewControllers{
                    if let vc = c as? TrainingDistributionGraphViewController{
                        return vc.graphView
                    }else{
                        for grandChild in c.childViewControllers{
                            if let vc = grandChild as? TrainingDistributionGraphViewController{
                                return vc.graphView
                            }
                        }
                    }
                }
            }
        }
        return nil
    }
   
    private func getBucketView(fromVCs vcs: [NSViewController]) -> BucketsViewController?{
        for child in vcs{
            if let vc = child as? BucketsViewController{
                return vc
            }
        }
        for child in vcs{
            if let bvc = getBucketView(fromVCs: child.childViewControllers){
                return bvc
            }
        }
        return nil
    }
    
    
}
