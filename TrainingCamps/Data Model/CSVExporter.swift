//
//  CSVExporter.swift
//  TrainingCamps
//
//  Created by Steven Lord on 04/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class CSVExporter{
    
    var dateFormatter: DateFormatter{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }
    
    //we append a bespoke first col to give visualisation of the tree
    func createCSV(forTree tree: [TreeNode], _ properties: [String]) -> String{
        var cString: String = ""
        cString += "node,"
        cString += createHeaderRow(properties)
        cString += "\n"
        
        cString += createCSVNoHeaders(forTree: tree, properties, currentDepth: 0)
        
        return cString
        
    }
    
    func createCSV(forObjs objs: [NSObject], _ properties: [String]) -> String{
        var cString: String = ""
        cString += createHeaderRow(properties)
        cString += "\n"
        
        for o in objs{
            cString += csv(o, properties)
            cString += "\n"
        }
        return cString
    }
    
    private func createCSVNoHeaders(forTree tree: [TreeNode], _ properties: [String], currentDepth: Int) -> String{
        var cString: String = ""
    
        for node in tree.sorted(by: {$0.date! < $1.date!}){
            if currentDepth > 0{
                for _ in 1...currentDepth{
                    cString += "-"
                }
            }
            cString += " " + (node.treeNodeName ?? "")
            cString += ","
            if let obj = node as? NSObject{
                cString += csv(obj, properties)
            }
            cString += "\n"
            if node.childCount > 0{
                cString += createCSVNoHeaders(forTree: node.children, properties, currentDepth: currentDepth + 1)
            }
        }
        return cString
        
    }
    
    private func csv(_ obj: NSObject, _ properties: [String]) -> String{
        var result: String = ""
        
        for p in properties{
            if let value = obj.value(forKey: p){
                if let v = value as? String{
                    result += v
                }else if let d = value as? Date{
                    result += dateFormatter.string(from: d)
                }else if let d = value as? Double{
                    result += String(format: "%.8f",d)
                }else{
                    result += String(describing: value)
                }
            }
            result += ","
        }
        return result.trimmingCharacters(in: CharacterSet(charactersIn: ","))
    }
    
    private func createHeaderRow(_ properties: [String]) -> String{
        var result: String = ""
        
        for p in properties{
            result += p
            result += ","
        }
        
        return result.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
    }
}
