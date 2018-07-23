//
//  DistributionSelectionViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 21/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class DistributionSelection: NSObject{
    @objc var name: String
    @objc var include: Bool = true
    
    var isGender:       Bool { return _isGender}
    var isRole:         Bool { return _isRole}
    var isCompletion:   Bool { return _isCompletion}
    var isCampType:     Bool { return _isCampType}

    private var _isGender:      Bool = false
    private var _isRole:        Bool = false
    private var _isCompletion:  Bool = false
    private var _isCampType:    Bool = false

    init(genderName: String){
        name = genderName
        _isGender = true
    }
    init(roleName: String){
        name = roleName
        _isRole = true
    }
    init(completionName: String){
        name = completionName
        _isCompletion = true
    }
    init(campType: String){
        name = campType
        _isCampType = true
    }
}

enum DistributionSelectionTypes: String{
    case Completers
    case NonCompleters = "Non Completers"
}

class DistributionSelectionViewController: NSViewController, CampGroupViewControllerProtocol{

    @objc var selectionTypes: [DistributionSelection] = []
    @IBOutlet var arrayController: NSArrayController!
    
    
    func setCampGroup(_ campGroup: CampGroup) {
        //filter out campType from seletionTypes
        let allObj = arrayController.arrangedObjects as! [Any]
        print(allObj.count)
        arrayController.remove(contentsOf: allObj)
        
        selectionTypes = []
        selectionTypes.append(DistributionSelection(completionName: DistributionSelectionTypes.Completers.rawValue))
        selectionTypes.append(DistributionSelection(completionName: DistributionSelectionTypes.NonCompleters.rawValue))
        selectionTypes.append(DistributionSelection(genderName: Gender.Female.rawValue))
        selectionTypes.append(DistributionSelection(genderName: Gender.Male.rawValue))
        for r in  Role.AllRoles{
            selectionTypes.append(DistributionSelection(roleName: r.rawValue))
        }
        // add this groups types
        for t in campGroup.campTypesArray(){
            let ds: DistributionSelection = DistributionSelection(campType: t.name ?? "")
            selectionTypes.append(ds)
        }

        arrayController.add(contentsOf: selectionTypes)
    }
    
    @IBAction func updateDistribution(_ sender: Any) {
        if let p = parent{
            if let vc = findNormalDistributionViewControllerProtocol(parentVC: p){
                vc.updateBuckets(forSelection: selectionTypes)
            }
        }
    }
    
    private func findNormalDistributionViewControllerProtocol(parentVC: NSViewController) -> NormalDistributionViewControllerProtocol?{
        if let vc = parentVC as? NormalDistributionViewControllerProtocol{
            return vc
        }else if let p = parentVC.parent{
            return findNormalDistributionViewControllerProtocol(parentVC: p)
        }
        return nil
    }
    
}
