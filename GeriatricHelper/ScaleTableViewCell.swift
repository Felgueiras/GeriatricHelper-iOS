//
//  ScaleTableViewCell.swift
//  GeriatricHelper
//
//  Created by felgueiras on 24/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class ScaleTableViewCell: UITableViewCell {
    
    
    
    var scale:GeriatricScale?
    
    @IBOutlet weak var infoButton: UIButton!
    
    
    @IBAction func infoButtonClicked(_ sender: Any) {
        
 
        
        // display popover
        let popOverVC = UIStoryboard(name: "PopOvers", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        
        popOverVC.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover: UIPopoverPresentationController = popOverVC.popoverPresentationController!
        popover.sourceView = self.infoButton
        popover.sourceRect = self.infoButton.bounds
        
        popOverVC.scale = scale
        
        self.viewController?.present(popOverVC, animated: true, completion:nil)
        
        
    }
    
    var viewController:UIViewController?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var resultQualitative: UILabel!
    
    @IBOutlet weak var resultQuantitative: UILabel!
    
    // create the cell
    static func createCell(cell: ScaleTableViewCell,
                           scale: GeriatricScale,
                           viewController: UIViewController) -> UITableViewCell{
        
     
        cell.scale = scale
        cell.viewController = viewController
        
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
