//
//  HallOfFameViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 29/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class HallOfFameViewController: CampGroupViewController{
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var races:  [RaceDefinition]{ return campGroup?.raceDefinitionArray() ?? []}

    override func setCampGroup(_ campGroup: CampGroup) {
        super.setCampGroup(campGroup)
        print("!!!!!!!!!!!!")
        collectionView.reloadData()
    }
    
}


extension HallOfFameViewController : NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return  races.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3 // overall, male, female
    }
    
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HallOfFameViewItem"), for: indexPath)

        guard let collectionViewItem = item as? HallOfFameViewItem else {return item}

        if indexPath.section < races.count{
            let race: RaceDefinition = races[indexPath.section]
            if indexPath.item == 0{
                collectionViewItem.results = race.overallTopTen()
                collectionViewItem.resultTitle.stringValue = race.name ?? "Not Set"
            }else if indexPath.item == 1{
                collectionViewItem.results = race.femaleTopTen()
                collectionViewItem.resultTitle.stringValue = "Female"
            }else if indexPath.item == 2{
                collectionViewItem.results = race.maleTopTen()
                collectionViewItem.resultTitle.stringValue = "Male"
            }

        }
        
        return item
    }

//    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
//        let view = collectionView.makeSupplementaryView(ofKind: NSCollectionView.SupplementaryElementKind.sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HallOfFameHeaderView"), for: indexPath)
//        
//        if let v = view as? HallOfFameHeaderView{
//            
//            v.title.stringValue = races[indexPath.section].name ?? "NOT SET"
//            
//            return v
//
//        }else{
//            return NSView.init()
//        }
//    }
    
}

extension HallOfFameViewController : NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: 1000, height: 40)
    }
}
