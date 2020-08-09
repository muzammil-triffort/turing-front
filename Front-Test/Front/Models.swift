//
//  Symbols.swift
//  Front
//
//  Created by Muzammil Mohammad on 09/08/20.
//  Copyright © 2020 Turing. All rights reserved.
//

import Foundation
import SwiftyJSON

class stockModel {

    var stockName: String   = ""
    var timestamp: NSNumber = 0
    var volume: NSNumber    = 0
    var open: Double        = 0
    var close: Double       = 0
    var high: Double        = 0
    var low: Double         = 0
    
    class func getStockBasicInfoModel(_ json: JSON) -> stockModel {
        
        let model = stockModel()
        model.stockName = ""
        model.close = 0
        
        return model
    }
}


