//
//  ScaleTableViewCell.swift
//  GeriatricHelper
//
//  Created by felgueiras on 24/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class ScaleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var resultQualitative: UILabel!
    
    @IBOutlet weak var resultQuantitative: UILabel!
    
    static func createCell(cell: ScaleTableViewCell, scale: GeriatricScale) -> UITableViewCell{
    
     
        
        cell.name.text = scale.scaleName
        
        if scale.completed == true{
            // generate quantitative result
            
            SessionHelper.generateScaleResult(scale: scale)
            
            // quantitative result
            var quantitative:String = ""
            quantitative += String(describing: scale.result!)
            
            var testNonDB = Constants.getScaleByName(scaleName: scale.scaleName!)
            
            
            
            if testNonDB?.scoring != nil {
                if testNonDB?.scoring?.differentMenWomen == false{
                    quantitative += " (" + String(describing: testNonDB!.scoring!.minScore!)
                    quantitative += "-" + String(describing: testNonDB!.scoring!.maxScore!)
                    quantitative += ")"
                } else {
                    if Constants.patientGender == "male" {
                        quantitative += " (" + String(describing: testNonDB!.scoring!.minMen!)
                        quantitative += "-" + String(describing: testNonDB!.scoring!.maxMen!)
                        quantitative += ")"
                    }
                }
            } else {
                quantitative = "";
            }
            
            cell.resultQuantitative?.text = String(describing: quantitative)
            
            
            
            let match = SessionHelper.getGradingForScale(scale: scale, gender: "male")
            if match != nil{
                cell.resultQualitative.text = String(describing: match!.grade!)
            }
            
            
            
        }
        else
        {
            
            cell.resultQualitative?.text = ""
            cell.resultQuantitative?.text = ""
        }
        
        return cell

    }
}
