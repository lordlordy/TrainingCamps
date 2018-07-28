//
//  HallOfFameEddingtonNumbersViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 02/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa
class HallOfFameEddingtonNumbersViewController: CampGroupViewController{
    
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    private var participantCount: Int {
        return campGroup?.participantArray().filter({$0.campsAttended > 0}).count ?? 0
    }
    
    var topTens: [(title: String, overall: [HallOfFameResult], female: [HallOfFameResult], male: [HallOfFameResult])] = []
    
    
    override func setCampGroup(_ campGroup: CampGroup) {
        super.setCampGroup(campGroup)
        
        topTens = []
        
        for a in Activity.Eddington{
            for u in a.validEddingtonUnits(){
                let top = campGroup.topTenEddingtonNumbers(forActivity: a, unit: u)
                topTens.append((titleFor(a,u), top.overall, top.female, top.male))
            }
        }
                
    }
    
    private func titleFor(_ a: Activity, _ u: Unit) -> String{
        return a.rawValue + ":" + u.rawValue + " Eddington Number"
    }
}

extension HallOfFameEddingtonNumbersViewController : NSCollectionViewDataSource {
    
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
//                collectionViewItem.resultTitle.stringValue = topTens[indexPath.section].title
                collectionViewItem.resultTitle.stringValue = "Overall"
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
            v.title.stringValue = topTens[indexPath.section].title ?? "NOT SET"
            v.subTitle.stringValue = "( " + String(participantCount) + " participants )"
        }
        return view
    }
    
}

extension HallOfFameEddingtonNumbersViewController : NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: 1000, height: 47)
    }
    
    func collectionView(_: NSCollectionView, layout: NSCollectionViewLayout, sizeForItemAt: IndexPath) -> NSSize{
        return NSSize(width: 340   , height: 214   )
    }
    
    
}
