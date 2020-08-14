//
//  StockViewController.swift
//  Front
//
//  Created by Muzammil Mohammad on 09/08/20.
//  Copyright © 2020 Turing. All rights reserved.
//

import UIKit

public let ScreenWidth = UIScreen.main.bounds.width
public let ScreenHeight = UIScreen.main.bounds.height

class StockViewController: UIViewController {

    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var calendarSegment: UISegmentedControl!
    @IBOutlet weak var symbolSegment: UISegmentedControl!

    var chartType: HSChartType = .timeLineForDay

    var symbolsArray: Array<Any>!
    var jsonArray: Array<HSKLineModel>!
    
    var selectedJSON: String = "responseQuotesWeek"
    var selectedSymbol: String = "AAPL"
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Front - Turing - Candlestick"
        
        self.jsonArray = getStockData(forJSON: self.selectedJSON, symbol: "AAPL")
        
        self.loadHSStock()
    }
    
    @IBAction func calendarValueChanged(_ sender: UISegmentedControl?) {
       
        switch sender?.selectedSegmentIndex {
            
        case 0:
            self.selectedJSON = "responseQuotesWeek"
            self.chartType = .kLineForWeek
            break
        case 1:
             self.selectedJSON = "responseQuotesMonth"
             self.chartType = .kLineForMonth
             break;
        default:
            self.selectedJSON = "responseQuotesWeek"
            self.chartType = .kLineForWeek
        }
        
        if self.selectedSymbol == "Dummy" {
            self.loadDummyStock()
        }
        else {
            self.resetValues()
        }
    }
    
    @IBAction func symbolValueChanged(_ sender: UISegmentedControl?) {
       
        if sender?.selectedSegmentIndex == 3 {
            self.selectedSymbol = "Dummy"
            self.loadDummyStock()
        }
        else
        {
            switch sender?.selectedSegmentIndex {
            case 0:
                self.selectedSymbol = "AAPL"
                break
            case 1:
                self.selectedSymbol = "MSFT"
                break
            case 2:
                self.selectedSymbol = "SPY"
                break
            default:
                self.selectedSymbol = "AAPL"
            }
            self.resetValues()
        }
    }
    
    func resetValues() {
        
        self.jsonArray = getStockData(forJSON: self.selectedJSON, symbol: self.selectedSymbol)
        self.loadHSStock()
    }
    
    func loadHSStock() {
        
        for view in self.chartContainerView.subviews {
            view.removeFromSuperview()
        }
        
        let chartRect = CGRect(x: 0, y: 0, width: ScreenWidth, height: self.chartContainerView.frame.size.height)
        let stockChartView = HSKLineView(frame: chartRect, kLineType: self.chartType, theme: HSKLineStyle())
        stockChartView.tag = chartType.rawValue
        let tmpDataK = Array(self.jsonArray[0 ..< self.jsonArray.count])
        stockChartView.configureView(data: tmpDataK)
        stockChartView.frame =  CGRect(x: 0, y: 0, width: ScreenWidth, height: self.chartContainerView.frame.size.height)
        self.chartContainerView.addSubview(stockChartView)
    }
    
    func loadDummyStock() {
        
        for view in self.chartContainerView.subviews {
            view.removeFromSuperview()
        }
        
        let weeklyKLineViewController = ChartViewController()

        if self.selectedJSON == "responseQuotesWeek" {
            weeklyKLineViewController.chartType = HSChartType.kLineForWeek
        }
        else {
             weeklyKLineViewController.chartType = HSChartType.kLineForMonth
        }
        
        weeklyKLineViewController.chartRect = CGRect(x: 0, y: 0, width: ScreenWidth, height: chartContainerView.frame.size.height)
        weeklyKLineViewController.view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: chartContainerView.frame.size.height)
        self.chartContainerView.addSubview(weeklyKLineViewController.view)
    }
}

