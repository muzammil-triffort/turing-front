//
//  PerformaceViewController.swift
//  Front
//
//  Created by Muzammil Mohammad on 10/08/20.
//  Copyright © 2020 Turing. All rights reserved.
//

import Foundation
import UIKit

class PerformaceViewController: UIViewController {
    
    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var jsonArray: Array<PerformaceModel>!
    var selectedJSON: String = "week"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Front - Turing - Performance", comment: "")
        
        self.chartContainerView.isUserInteractionEnabled = true
        self.jsonArray = getPerformanceData(forJSON: "responseQuotesWeek")
  
        self.showChart()
    }
    
    @IBAction func calendarValueChanged(_ sender: UISegmentedControl?) {
       
        switch sender?.selectedSegmentIndex {
            
        case 0:
            self.selectedJSON = "week"
            self.jsonArray = getPerformanceData(forJSON: "responseQuotesWeek")
            break
        case 1:
            self.selectedJSON = "month"
             self.jsonArray = getPerformanceData(forJSON: "responseQuotesMonth")
             break;
        default:
            self.selectedJSON = "week"
            self.jsonArray = getPerformanceData(forJSON: "responseQuotesWeek")
        }
        
        self.showChart()
    }
    
    func showChart() {
        
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
        
        let count = self.jsonArray.count - 1
        let lineSpacing: Int = 20
        let width: Double = Double(count * lineSpacing)
        let height: Double = Double(self.scrollView.frame.size.height)
        
        let chart = Chart(frame: CGRect(x: 0, y: 0, width: Int(width), height: Int(height)))
        
        chart.minX = Double(lineSpacing)

        var datesArray: Array<String> = Array()
        var series1Array: Array<Double> = Array()
        var series2Array: Array<Double> = Array()
        var series3Array: Array<Double> = Array()
        
        for n in 0...count {

            let model: PerformaceModel = self.jsonArray[n]
            series1Array.append(model.aapl)
            series2Array.append(model.msft)
            series3Array.append(model.spy)
            
            if self.selectedJSON == "week" {
                datesArray.append(model.hours)
            }
            else {
                datesArray.append(model.date)
            }
        }
                
        let series1 = ChartSeries(series1Array)
        series1.color = ChartColors.yellowColor()
        series1.area = true

        let series2 = ChartSeries(series2Array)
        series2.color = ChartColors.redColor()
        series2.area = true

        let series3 = ChartSeries(series3Array)
        series3.color = ChartColors.purpleColor()
        series3.area = true
        
        chart.showXLabelsAndGrid = true
        chart.xLabelsSkipLast = false
        chart.xStringLabels = datesArray
        chart.add([series1, series2, series3])
        
        self.scrollView.addSubview(chart)
        self.scrollView.contentSize = CGSize(width: width, height: height)
    }
}
