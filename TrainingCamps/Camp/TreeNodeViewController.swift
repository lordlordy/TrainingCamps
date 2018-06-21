//
//  TreeNodeViewController.swift
//  TrainingCamps
//
//  Created by Steven Lord on 14/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa
class TreeNodeViewController: NSViewController{
    
    @objc dynamic var treeNodes: [TreeNode] = []{
        didSet{
            print("Tree nodes set to:")
            for t in treeNodes{
                print(t)
                print(t.name)
                for c in t.children{
                    print("--> \(c.name)")
                    
                }
            }
            
        }
    }
 
    @IBAction func toggleTree(_ sender: Any){
        print("Toggling")
        if let nr = nextResponder{
            tryNextResponder(nr,sender:sender)
        }
        
    }
    
    private func tryNextResponder(_ nr: NSResponder, sender: Any){
        
        print("trying \(nr)")
        if let tt = nr as? TreeToggler{
            tt.toggleTree()
        }else{
            if let next = nr.nextResponder{
                tryNextResponder(next, sender:sender)
            }

        }
    }
    
}
