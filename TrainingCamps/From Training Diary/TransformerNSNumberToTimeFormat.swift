//
//  TransformerNSNumberToTimeFormat.swift
//  TrainingCamps
//
//  Created by Steven Lord on 13/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class TransformerNSNumberToTimeFormat: ValueTransformer {
    
    var includeHours: Bool = true
    
    //What do I transform
    override class func transformedValueClass() -> AnyClass {return NSNumber.self}
    
    override class func allowsReverseTransformation() -> Bool {return true}
    
    override func transformedValue(_ value: Any?) -> Any? {
        var s: Int = 0
        if let intS = value as? Int{
            s = intS
        }else if let doubleS = value as? Double{
            if doubleS.isNaN || doubleS.isInfinite{
                return nil
            }
            s = Int(doubleS)
        }else{
            return nil
        }
        
        let isNegative: Bool = s < 0
        
        let secs = abs(s) % 60
        let mins = (abs(s) / 60) % 60
        let hours = (abs(s) / 3600)
        if isNegative{
            if includeHours{
                return String(format: "-%02d:%02d:%02d", hours, mins, secs)
            }else{
                return String(format: "-%02d:%02d", mins, secs)
            }
        }else{
            if includeHours{
                return String(format: "%02d:%02d:%02d", hours, mins, secs)
            }else{
                return String(format: "%02d:%02d", mins, secs)
            }
        }
        
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let type = value as? NSString else { return nil }
        
        let myString: String = type as String
        let isNegative: Bool = myString.hasPrefix("-")
        let b = myString.split(separator: ":") as [NSString]
        var total = 0
        if b.count == 1{
            total = abs(b[0].integerValue*3600)
        }else if b.count == 2{
            total = abs(b[0].integerValue*3600) + b[1].integerValue*60
        }else{
            total = abs(b[0].integerValue*3600) + b[1].integerValue*60 + b[2].integerValue
        }
        if isNegative{
            total = -1 * total
        }
        return NSNumber(value: total)
    }
}
