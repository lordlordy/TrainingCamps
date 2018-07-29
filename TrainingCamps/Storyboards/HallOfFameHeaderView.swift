//
//  HallOfFameHeaderView.swift
//  TrainingCamps
//
//  Created by Steven Lord on 29/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class HallOfFameHeaderView: NSView {

    @IBOutlet weak var title: NSTextField!
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let clickRecogniser = NSClickGestureRecognizer(target: self, action: #selector(doubleClick))
        
        clickRecogniser.numberOfClicksRequired = 2
        
        self.addGestureRecognizer(clickRecogniser)
        
        
        // Drawing code here.
    }
    
    @objc func doubleClick(_ sender: Any?){
        print("Double clicked")
        if let g = sender as? NSClickGestureRecognizer{
            print(g.target)
            if let hv = g.target as? HallOfFameHeaderView{
                
                print(hv.superview)
                if let cv = hv.superview as? NSCollectionView{
                    
                    cv.toggleSectionCollapse(hv)
                }
            }
        }
    }
    
}
