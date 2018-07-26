//
//  CampCompletionCertificationViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 03/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class CampCompletionCertificationViewController: NSViewController, CampParticipantViewControllerProtocol, CampViewControllerProtocol{

    
    
    
    @IBOutlet var certificateView: NSView!
    @IBOutlet weak var campGraph: DistributionGraph!
    @IBOutlet weak var dayGraph: DistributionGraph!
    
    @objc dynamic var camp: Camp?
    @objc dynamic var campParticipant: CampParticipant?
    @objc dynamic var campParticipantArray: [CampParticipant] = []
    @objc dynamic var trainingNodes: [TreeNode] = []
    
    
    @objc dynamic var logoURL: URL? {
        return Bundle.main.url(forResource: "et_final_Transparent", withExtension: "jpg")
    }
    
    @objc dynamic var footer: String = ""
    
    private var hourMinuteFormatter: (Double) -> String = { // this is hours:minutes - so no seconds
        let s: Int = Int($0)
        let mins = (abs(s) / 60) % 60
        let hours = (abs(s) / 3600)
        return String(format: "%02d:%02d", hours, mins)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let cg = camp?.campGroup{
            let dayData = cg.participantDaysArray().filter({$0.totalSeconds > 0.0})
            let dayBucketGenerator = FixedWidthBucketGenerator(startingAt: 0.0, width: 30.0 * 60.0)
            let dayBuckets = dayBucketGenerator.createBuckets(forDoubleProperty: TrainingDataProtocolProperty.totalSeconds, data: dayData)
            let dayStdDevMean = Maths().stdDevMeanTotal(dayData.map({$0.totalSeconds}))
            let dayLogStdDevMean = Maths().stdDevMeanTotal(dayData.map({log($0.totalSeconds)}))

            dayGraph.set(buckets: dayBuckets, mean: dayStdDevMean.mean, variance: pow(dayStdDevMean.stdDev,2.0))
            dayGraph.setLogNormal(meanOfLogs: dayLogStdDevMean.mean, stdDevOfLogs: dayLogStdDevMean.stdDev)
            dayGraph.xAxisFormatter = hourMinuteFormatter
            
            let campData = cg.campParticipantsArray().filter({$0.totalSeconds > 0.0})
            let campBucketGenerator = FixedWidthBucketGenerator(startingAt: 0.0, width: 60.0 * 60.0)
            let campBuckets = campBucketGenerator.createBuckets(forDoubleProperty: TrainingDataProtocolProperty.totalSeconds, data: campData)
            let campStdDevMean = Maths().stdDevMeanTotal(campData.map({$0.totalSeconds}))
            let campLogStdDevMean = Maths().stdDevMeanTotal(campData.map({log($0.totalSeconds)}))

            campGraph.set(buckets: campBuckets, mean: campStdDevMean.mean, variance: pow(campStdDevMean.stdDev,2.0))
            campGraph.setLogNormal(meanOfLogs: campLogStdDevMean.mean, stdDevOfLogs: campLogStdDevMean.stdDev)
            campGraph.xAxisFormatter = hourMinuteFormatter

        }

    }
    
    func setCamp(_ camp: Camp) {
        self.camp = camp
    }
    
    
    func setCampParticipant(_ campParticipant: CampParticipant) {
        self.campParticipant = campParticipant
        campParticipantArray = [campParticipant]
        setFooter()
        createTreeViews(campParticipant)
        
        let campSeconds: Double = campParticipant.totalSeconds
        let daySeconds: [Double] = campParticipant.getDays().map({$0.totalSeconds})
        
        campGraph.setHighlighted(x: [campSeconds])
        dayGraph.setHighlighted(x: daySeconds)
        
    }
    
    
    private func setFooter(){
        footer = ""
        if let camp = campParticipant?.camp{
            footer += camp.campName ?? "Not Set"
            let df = DateFormatter()
            df.dateFormat = "dd-MMM-yy"
            footer += " ( "
            footer += df.string(from: camp.campStart!)
            footer += " -> "
            footer += df.string(from: camp.campEnd!)
            footer += " )"
        }
    }
    
    private func createTreeViews(_ cp: CampParticipant){
        let rootNode = TreeNodeSum(name: cp.camp!.campName!, date: cp.camp!.campStart!, includeInAggregation: true, campName: cp.camp!.campName!, nodeType: TreeNodeType.Root)
        for day in cp.getDays().sorted(by: {$0.day!.date! < $1.day!.date!}){
            rootNode.addChild(ParticipantDayTreeNode(day))
        }
        rootNode.rankChildren()
        rootNode.leavesShow(trainingLeafNameType: TrainingLeafNameType.DayOfWeek.rawValue, racingLeafNameType: RacingLeafNameType.RaceName.rawValue)
        trainingNodes = [rootNode]
    }
    
}
