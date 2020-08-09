//
//  StockViewController.swift
//  Front
//
//  Created by Muzammil Mohammad on 09/08/20.
//  Copyright © 2020 Turing. All rights reserved.
//

import UIKit
import HSStockChart
import Charts

public let ScreenWidth = UIScreen.main.bounds.width
public let ScreenHeight = UIScreen.main.bounds.height

class StockViewController: UIViewController {

    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var calendarSegment: UISegmentedControl!
    @IBOutlet weak var symbolSegment: UISegmentedControl!
    //@IBOutlet var chartView: CandleStickChartView!

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
            break
        case 1:
             self.selectedJSON = "responseQuotesMonth"
             break;
        default:
            self.selectedJSON = "responseQuotesWeek"
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
        let stockChartView = HSKLineView(frame: chartRect, kLineType: .kLineForWeek, theme: HSKLineStyle())
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
    
    //Chart libarry
//    func setupCharts() {
//
//        chartView.chartDescription?.enabled = false
//
//        chartView.dragEnabled = false
//        chartView.setScaleEnabled(true)
//        chartView.maxVisibleCount = 200
//        chartView.pinchZoomEnabled = true
//
//        chartView.legend.horizontalAlignment = .right
//        chartView.legend.verticalAlignment = .top
//        chartView.legend.orientation = .vertical
//        chartView.legend.drawInside = false
//        chartView.legend.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
//
//        chartView.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
//        chartView.leftAxis.spaceTop = 0.3
//        chartView.leftAxis.spaceBottom = 0.3
//        chartView.leftAxis.axisMinimum = 0
//
//        chartView.rightAxis.enabled = false
//
//        chartView.xAxis.labelPosition = .bottom
//        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
//
//        self.chartContainerView.addSubview(chartView)
//    }
//
//    func loadCharts() {
//
//        self.setupCharts()
//
//        let count: Int = self.jsonArray.count
//
//        let yVals1 = (0..<count).map { (i) -> CandleChartDataEntry in
//
//            let model: HSKLineModel = self.jsonArray[i]
//
//            let val = Double(model.volume)
//            let high = Double(model.high)
//            let low = Double(model.low)
//            let open = Double(model.open)
//            let close = Double(model.close)
//            let even = i % 2 == 0
//
//            return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close, icon: nil)
//        }
//
//        let set1 = CandleChartDataSet(entries: yVals1, label: "")
//        set1.axisDependency = .left
//        set1.setColor(UIColor(white: 80/255, alpha: 1))
//        set1.drawIconsEnabled = false
//        set1.shadowColor = .darkGray
//        set1.shadowWidth = 0.7
//        set1.decreasingColor = .red
//        set1.decreasingFilled = true
//        set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
//        set1.increasingFilled = true
//        set1.neutralColor = .blue
//
//        let data = CandleChartData(dataSet: set1)
//        chartView.data = data
//    }
        
}

