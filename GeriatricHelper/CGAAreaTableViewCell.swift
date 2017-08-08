//
//  CGAAreaTableViewCell.swift
//  GeriatricHelper
//
//  Created by felgueiras on 15/05/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class CGAAreaTableViewCell: UITableViewCell, UIPopoverPresentationControllerDelegate {

    
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
        popover.delegate = self

        switch area! {
        case Constants.cga_functional:
            popOverVC.displayText = FirebaseRemoteConfig.getStringFirebase(key: "cga_functional")
            break;
        case Constants.cga_afective:
            popOverVC.displayText = FirebaseRemoteConfig.getStringFirebase(key:"cga_afective")
            break;
        case Constants.cga_nutritional:
            popOverVC.displayText = FirebaseRemoteConfig.getStringFirebase(key:"cga_nutritional")
            break;
        case Constants.cga_cognitive:
            popOverVC.displayText = FirebaseRemoteConfig.getStringFirebase(key:"cga_cognitive")
            break;
        case Constants.cga_march:
            popOverVC.displayText = FirebaseRemoteConfig.getStringFirebase(key:"cga_march")
            break;
        default:
            popOverVC.displayText = ""
        }
        
        self.viewController?.present(popOverVC, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle
    {
        return .none
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
        case Constants.cga_functional:
            cell.areaIcon?.image = #imageLiteral(resourceName: "ic_functional")
        case Constants.cga_afective:
            cell.areaIcon?.image = #imageLiteral(resourceName: "cga_afective")
        case Constants.cga_march:
            cell.areaIcon?.image = #imageLiteral(resourceName: "cga_march")
        case Constants.cga_cognitive:
            cell.areaIcon?.image = #imageLiteral(resourceName: "ic_mental")
        case Constants.cga_nutritional:
            cell.areaIcon?.image = #imageLiteral(resourceName: "ic_nutritional")
        default:
            cell.areaIcon?.image = #imageLiteral(resourceName: "icon_small")
        }
        
        
        return cell
        
    }
    
    
    
    
}
