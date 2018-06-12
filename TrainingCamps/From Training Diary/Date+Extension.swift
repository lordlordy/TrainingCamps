//
//  Date+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation


extension Date{
    
    public func jsonString() ->String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    static func dateFromJSONString(_ s: String) -> Date?{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: s)
    }
    
}
