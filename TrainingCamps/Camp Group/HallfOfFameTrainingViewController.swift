//
//  HallfOfFameTrainingViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 02/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class HallOfFameTrainingViewController: CampGroupViewController{


    @IBOutlet weak var collectionView: NSCollectionView!
    
    private var participantDaysCount: Int{
        return campGroup?.participantDaysArray().count ?? 0
    }
    
    private var participantCampsCount: Int{
        return campGroup?.campParticipantsArray().count ?? 0
    }
    
    var topTens: [(title: String, overall: [HallOfFameResult], female: [HallOfFameResult], male: [HallOfFameResult], isDay: Bool)] = []


    override func setCampGroup(_ campGroup: CampGroup) {
        super.setCampGroup(campGroup)
        
        topTens = []
        
        for a in Activity.HallOfFame{
            for u in a.hallOfFameUnits(){
                var top = campGroup.topTen(forActivity: a, unit: u, isDay: true)
                topTens.append((titleFor(a,u,true), top.overall, top.female, top.male, true))
                top = campGroup.topTen(forActivity: a, unit: u, isDay: false)
                topTens.append((titleFor(a,u,false), top.overall, top.female, top.male, false))
            }
        }
    
        
    }
    
    private func titleFor(_ a: Activity, _ u: Unit, _ isDay: Bool) -> String{
        var str: String = isDay ? "Daily " : "Camp "
        str += a.rawValue + " "
        switch u{
        case .Seconds: str += " Duration"
        default: str += u.rawValue
        }
        return str
    }
}

extension HallOfFameTrainingViewController : NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return  topTens.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3 // overall, male, female
    }
    
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HallOfFameViewItem"), for: indexPath)
        
        guard let collectionViewItem = item as? HallOfFameViewItem else {return item}
        
        
        
        if indexPath.section < topTens.count{
            if indexPath.item == 0{
                collectionViewItem.results = topTens[indexPath.section].overall
                collectionViewItem.resultTitle.stringValue = "Overall"
//                collectionViewItem.resultTitle.stringValue = topTens[indexPath.section].title
            }else if indexPath.item == 1{
                collectionViewItem.results = topTens[indexPath.section].female
                collectionViewItem.resultTitle.stringValue = "Female"
            }else if indexPath.item == 2{
                collectionViewItem.results = topTens[indexPath.section].male
                collectionViewItem.resultTitle.stringValue = "Male"
            }
            
        }
        
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        
        let view = collectionView.makeSupplementaryView(ofKind: NSCollectionView.SupplementaryElementKind.sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HallOfFameHeaderView"), for: indexPath)
        
        if let v = view as? HallOfFameHeaderView{
            v.title.stringValue = topTens[indexPath.section].title
            if topTens[indexPath.section].isDay{
                v.subTitle.stringValue = "( " + String(participantDaysCount) + " participant days )"
            }else{
                v.subTitle.stringValue = "( " + String(participantCampsCount) + " participant camps )"

            }
        }
        return view
    }
    
}

extension HallOfFameTrainingViewController : NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: 1000, height: 47)
    }
    
    func collectionView(_: NSCollectionView, layout: NSCollectionViewLayout, sizeForItemAt: IndexPath) -> NSSize{
        return NSSize(width: 340   , height: 214   )
    }
    
    
}
