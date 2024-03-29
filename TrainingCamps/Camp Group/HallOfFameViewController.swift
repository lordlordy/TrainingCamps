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
    
    var races:  [RaceDefinition]{ return campGroup?.raceDefinitionArray().sorted(by: {$0.raceResultsArray().count > $1.raceResultsArray().count}) ?? []}

    override func setCampGroup(_ campGroup: CampGroup) {
        super.setCampGroup(campGroup)
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
                collectionViewItem.resultTitle.stringValue = "Overall"
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

    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        
        switch kind{
        case NSCollectionView.elementKindSectionHeader:
            let view = collectionView.makeSupplementaryView(ofKind: NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HallOfFameHeaderView"), for: indexPath)
            
            if let v = view as? HallOfFameHeaderView{
                if let name = races[indexPath.section].name{
                    v.title.stringValue = name
                }else{
                    v.title.stringValue = "NOT SET"
                }
            }
            return view
        case NSCollectionView.elementKindSectionFooter:
            let view = collectionView.makeSupplementaryView(ofKind: NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HallOfFameFooterView"), for: indexPath) as! HallOfFameFooterView
            let race = races[indexPath.section]
            let numberOfResults = race.raceResultsArray().count
            let maleResults = race.raceResultsArray().filter({$0.campParticipant?.participant?.gender == Gender.Male.rawValue}).count
            let femaleResults = race.raceResultsArray().filter({$0.campParticipant?.participant?.gender == Gender.Female.rawValue}).count
            view.title.stringValue = String(numberOfResults) + " results - " + String(femaleResults) + "  female / " + String(maleResults) +  " male"
            return view
        default:
            print("Not using \(kind)")
            return NSView()
        }
        

    }
    
}

extension HallOfFameViewController : NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: 1000, height: 25   )
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForFooterInSection section: Int) -> NSSize {
        return NSSize(width: 1000, height: 25   )
    }
    
    func collectionView(_: NSCollectionView, layout: NSCollectionViewLayout, sizeForItemAt: IndexPath) -> NSSize{
        return NSSize(width: 340   , height: 214   )
    }
    
    
}
