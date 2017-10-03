//
//  ScaleTableViewCell.swift
//  GeriatricHelper
//
//  Created by felgueiras on 24/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class ScaleTableViewCell: UITableViewCell, UIPopoverPresentationControllerDelegate {
    
    
    
    var scale:GeriatricScale?
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var notes: UITextField!
    
    @IBAction func infoButtonClicked(_ sender: Any) {
        
        // display popover
        let popOverVC = UIStoryboard(name: "PopOvers", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! ScaleInfoViewController
        
        popOverVC.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // access the presentation controller
        let popover: UIPopoverPresentationController = popOverVC.popoverPresentationController!
        popover.sourceView = self.infoButton
        popover.sourceRect = self.infoButton.bounds
        popover.delegate = self
        
        popOverVC.scale = scale
        
        // present popover
        self.viewController?.present(popOverVC, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle
    {
        return .none
    }
    
    var viewController:UIViewController?
    
    @IBAction func notesUpdated(_ sender: Any) {
        // save notes to scale
        scale!.notes = notes.text
        
    }
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var subCategory: UILabel!
    @IBOutlet weak var resultQualitative: UILabel!
    
    @IBOutlet weak var resultQuantitative: UILabel!
    
    // create the cell
    static func createCell(cell: ScaleTableViewCell,
                           scale: GeriatricScale,
                           viewController: UIViewController) -> UITableViewCell{
        
     
        cell.scale = scale
        cell.viewController = viewController
        
        cell.name.text = scale.scaleName
        
        // display subcategory for functional area scales
        print(scale.area!)
        if scale.area! == Constants.cga_functional {
            cell.subCategory.text = scale.subCategory!
        }
        else{
            cell.subCategory.isHidden = true
        }
        
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
