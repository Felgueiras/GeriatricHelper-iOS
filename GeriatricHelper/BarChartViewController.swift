//
//  BarChartViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 22/05/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: UIViewController , ChartViewDelegate{

    @IBOutlet weak var barChartView: BarChartView!
    
    
    var months: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChartView.delegate = self

        
   
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        setChart(dataPoints: months, values: unitsSold)
        
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
        print(entry)
    }
    
    
  
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
    
        var dataEntries: [BarChartDataEntry] = []
        
        // create entries (x,y)
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        barChartView.descriptionText = ""
        
        // set colors - can customize colors for each entry
        chartDataSet.colors = [
            UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1),
            UIColor(red: 5/255, green: 126/255, blue: 34/255, alpha: 1)
        ]
        
        // color templates
        chartDataSet.colors = ChartColorTemplates.colorful()
        
        
        barChartView.xAxis.labelPosition = .bottom
        
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        
        
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        
    
        let ll = ChartLimitLine(limit: 10.0, label: "Target")
        barChartView.rightAxis.addLimitLine(ll)

    }

 
    


}
