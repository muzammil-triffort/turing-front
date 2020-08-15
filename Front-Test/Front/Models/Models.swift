//
//  Symbols.swift
//  Front
//
//  Created by Muzammil Mohammad on 09/08/20.
//  Copyright © 2020 Turing. All rights reserved.
//

import Foundation
import SwiftyJSON

class StockModel {

    var stockName: String   = ""
    var timestamp: NSNumber = 0
    var volume: NSNumber    = 0
    var open: Double        = 0
    var close: Double       = 0
    var high: Double        = 0
    var low: Double         = 0
    
    class func getStockBasicInfoModel(_ json: JSON) -> StockModel {
        
        let model = StockModel()
        model.stockName = ""
        model.close = 0
        
        return model
    }
}

class PerformaceModel {

    var timestamp: Double = 0
    var aapl: Double        = 0
    var msft: Double        = 0
    var spy: Double         = 0
    var hours: String       = ""
    var date: String        = ""
    
    class func getStockBasicInfoModel(_ json: JSON) -> PerformaceModel {
        
        let model = PerformaceModel()
        model.aapl = 0.0
        model.msft = 0.0
        model.spy  = 0.0
        
        return model
    }
}

