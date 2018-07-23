//
//  HallOfFameResult.swift
//  TrainingCamps
//
//  Created by Steven Lord on 29/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

class HallOfFameResult: NSObject{
    
    @objc dynamic var rank: Int32 { return _rank}
    @objc dynamic var name: String { return _name}
    @objc dynamic var info: String { return _info}
    @objc dynamic var value: String {
        if let u = _unit{
            switch u{
            case .Seconds:
                let t = TransformerNSNumberToTimeFormat()
                return t.transformedValue(_value) as! String
            default:
                let nf: NumberFormatter = NumberFormatter()
                nf.format = "#,##0.0"
                return nf.string(from: NSNumber.init(value: _value)) ?? "Invalid"
            }
        }else{
            return String(_edNum)
        }
    }

    
    private var _rank: Int32 = 0
    private var _name: String = ""
    private var _info: String = ""
    private var _value: Double = 0.0
    private var _unit: Unit?
    private var _edNum: Int32 = 0
    
    init(_ rank: Int32, _ name: String, _ camp: String, value: Double, unit: Unit){
        _rank = rank
        _name = name
        _info = camp
        _value = value
        _unit = unit
    }
    
    init(_ rank: Int32, _ name: String, edNum: Int32, plusOne: Int32){
        _rank = rank
        _name = name
        _info = "+1 : " + String(plusOne)
        _edNum = edNum
    }
    

}
