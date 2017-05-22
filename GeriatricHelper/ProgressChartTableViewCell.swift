//
//  ProgressChartTableViewCell.swift
//  GeriatricHelper
//
//  Created by felgueiras on 22/05/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import Charts

class ProgressChartTableViewCell: UITableViewCell, ChartViewDelegate {

    var scale:GeriatricScale?
    var rowIndex:Int?
    
    @IBOutlet weak var scaleName: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var barChartView: BarChartView!
    
    var months: [String]!
    var sessions: [Session]!
    
    
    var viewController:UIViewController?
    
    
    // create the cell
    static func createCell(cell: ProgressChartTableViewCell,
                           scale: GeriatricScale,
                           viewController: UIViewController,
                           rowIndex: Int,
                           sessions: [Session]) -> UITableViewCell{
        
        cell.rowIndex = rowIndex
        cell.scale = scale
        cell.scaleName.text = scale.scaleName
        cell.viewController = viewController
        cell.sessions = sessions
        
        
        cell.barChartView.delegate = cell
        
        
        
        // Firebase ops
        var scaleInstances = FirebaseDatabaseHelper.getScaleInstancesForPatient(patientSessions: cell.sessions, scaleName: scale.scaleName!)
        
        // build chart
        var scalesDates:[String] = []
        var values:[Double] = []
        
        for i in 0..<scaleInstances.count{
            scalesDates.append(String(i))
            values.append(scaleInstances[i].result!)
        }
        
        
        cell.setChart(dataPoints: scalesDates, values: values)
        
        
        return cell
        
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        barChartView.noDataText = "Escala ainda não foi executada"
        
        if dataPoints.count == 0{
        return
        }
        
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
