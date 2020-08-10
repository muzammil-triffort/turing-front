//
//  AppController.swift
//  Front
//
//  Created by Muzammil Mohammad on 09/08/20.
//  Copyright © 2020 Turing. All rights reserved.
//

import Foundation
import SwiftyJSON
//import HSStockChart

func readLocalFile(forName name: String) -> Data? {
    do {
        if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            return jsonData
        }
    } catch {
        print(error)
    }
    
    return nil
}

func getStockData(forJSON name: String, symbol: String) -> [HSKLineModel] {
    
    do {
        if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
            
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            
            let data: Dictionary<String, Any> = try! JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, Any>
            
            let content = data["content"] as! Dictionary<String, Any>
            let quoteSymbol = content["quoteSymbols"] as! Array<Any>
            
            for items in quoteSymbol {
                
                let symbolData = items as! Dictionary<String, Any>
                let key = symbolData["symbol"] as! String
                
                if key == symbol {
                    
                    let timestamp   = symbolData["timestamps"] as! Array<Any>
                    let opens       = symbolData["opens"] as! Array<Any>
                    let closures    = symbolData["closures"] as! Array<Any>
                    let highs       = symbolData["highs"] as! Array<Any>
                    let lows        = symbolData["lows"] as! Array<Any>
                    let volumes     = symbolData["volumes"] as! Array<Any>
                    
                    let count = timestamp.count - 1
                    
                    var symbolArray: Array<HSKLineModel> = Array()
                    
                    for n in 0...count {
                                                
                        let model = HSKLineModel()
                                                
                        if highs.count >= n {
                            model.high = CGFloat((highs[n] as AnyObject).doubleValue)
                        }
                        if lows.count >= n {
                              model.low = CGFloat((lows[n] as AnyObject).doubleValue)
                        }
                        if opens.count >= n {
                              model.open = CGFloat((opens[n] as AnyObject).doubleValue)
                        }
                        if closures.count >= n {
                              model.close = CGFloat((closures[n] as AnyObject).doubleValue)
                        }
                        if volumes.count >= n {
                             model.volume    = CGFloat((volumes[n] as AnyObject).doubleValue)
                        }
                        if timestamp.count >= n {
                            
                            let time: Double = timestamp[n] as! Double
                            let date = dateStringFromUnixTime(unixTime: time)
                            
                            model.date = date
                        }
                        
                        symbolArray.append(model)
                    }
                    
                    return symbolArray
                }
            }
            
            return Array()
        }
    } catch {
        print(error)
    }
    
    return Array()
}

func dateStringFromUnixTime(unixTime: Double) -> String {
    let date = NSDate(timeIntervalSince1970: unixTime)

    let dateFormatter : DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMddHHmmss"
    let dateString = dateFormatter.string(from: date as Date)
    return dateString
}
