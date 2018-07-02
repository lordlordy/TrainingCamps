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
        
        print("Eddington Number tops tens set for \(topTens.count) categories")
        
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
                collectionViewItem.resultTitle.stringValue = topTens[indexPath.section].title
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
}
