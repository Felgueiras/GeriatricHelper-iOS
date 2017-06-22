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
    
    @IBOutlet weak var notes: UITextField!
    
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
    
    @IBAction func notesUpdated(_ sender: Any) {
        // save notes to scale
        scale!.notes = notes.text
        
    }
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
            
            // quantitative result
            let quantitativeResult = ScaleHelper.getQuantitativeResult(scale: scale)
            cell.resultQuantitative?.text = String(describing: quantitativeResult)
            
            // qualitative result
            let qualitativeResult = ScaleHelper.getQualitativeResult(scale: scale)
            cell.resultQualitative.text = String(describing: qualitativeResult)
            
        }
        else
        {
            
            cell.resultQualitative?.text = ""
            cell.resultQuantitative?.text = ""
        }
        
        if scale.notes != nil{
            cell.notes.text = scale.notes
        }
        
        
        
        return cell
        
    }
    
    
    
}
