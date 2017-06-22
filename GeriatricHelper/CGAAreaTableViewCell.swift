//
//  CGAAreaTableViewCell.swift
//  GeriatricHelper
//
//  Created by felgueiras on 15/05/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class CGAAreaTableViewCell: UITableViewCell {

    
    @IBOutlet weak var areaIcon: UIImageView!
    
    // name of the CGA area
    @IBOutlet weak var areaLabel: UILabel!
    
    @IBOutlet weak var completedScales: UILabel!
    var area:String?
    
    @IBOutlet weak var infoButton: UIButton!
    
    
    @IBAction func infoButtonClicked(_ sender: Any) {
        
        // display popover
        let popOverVC = UIStoryboard(name: "PopOvers", bundle: nil).instantiateViewController(withIdentifier: "textPopUp") as! TextPopUpViewController
        
        popOverVC.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover: UIPopoverPresentationController = popOverVC.popoverPresentationController!
        
        // set the source
        popover.sourceView = self.infoButton
        popover.sourceRect = self.infoButton.bounds

        switch area! {
        case Constants.functionalState:
            popOverVC.displayText = StringHelper.cga_functional
        case Constants.mentalState:
            popOverVC.displayText = StringHelper.cga_mental
        case Constants.socialState:
            popOverVC.displayText = StringHelper.cga_social
        case Constants.nutritionalState:
            popOverVC.displayText = StringHelper.cga_nutritional
        default:
            popOverVC.displayText = ""
        }
        
        self.viewController?.present(popOverVC, animated: true, completion:nil)
    }
    
    var viewController:UIViewController?
    
    
    // create the cell
    static func createCell(cell: CGAAreaTableViewCell,
                           area: String,
                           viewController: UIViewController,
                           scales: [GeriatricScale]) -> UITableViewCell{
        
        
        cell.area = area
        cell.viewController = viewController
        
        cell.areaLabel.text = area
        
        // display already completed scales
        var completedScales: [GeriatricScale]? = []
        
        // get scales for area
        for scale in scales{
            if scale.completed == true {
                completedScales?.append(scale)
            }
        }
        
        
        if completedScales!.count > 0{
            var completionText=""
            for scale in completedScales!{
                completionText += scale.shortName!+"   "
            
            }
            cell.completedScales.text=completionText
        }
        else{
            cell.completedScales.text=""
        }
        
        //display area icon
        switch area {
        case Constants.functionalState:
            cell.areaIcon?.image = #imageLiteral(resourceName: "ic_functional")
        case Constants.mentalState:
            cell.areaIcon?.image = #imageLiteral(resourceName: "ic_mental")
        case Constants.socialState:
            cell.areaIcon?.image = #imageLiteral(resourceName: "ic_social")
        case Constants.nutritionalState:
            cell.areaIcon?.image = #imageLiteral(resourceName: "ic_nutritional")
        default:
            cell.areaIcon?.image = #imageLiteral(resourceName: "icon_small")
        }
        
        
        return cell
        
    }
    
    
    
    
}
