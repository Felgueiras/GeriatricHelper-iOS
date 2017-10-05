//
//  CGAAreaTableViewCell.swift
//  GeriatricHelper
//
//  Created by felgueiras on 15/05/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class CGAGuideAreaTableViewCell: UITableViewCell, UIPopoverPresentationControllerDelegate {

    
    @IBOutlet weak var areaIcon: UIImageView!
    
    // name of the CGA area
    @IBOutlet weak var areaLabel: UILabel!
    
    @IBOutlet weak var areaDescription: UILabel!
    
    var area:String?
    
    @IBOutlet weak var infoButton: UIButton!
    
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle
    {
        return .none
    }
    
    var viewController:UIViewController?
    
    
    // create the cell
    static func createCell(cell: CGAGuideAreaTableViewCell,
                           area: String,
                           viewController: UIViewController) -> UITableViewCell{
        
        
        cell.area = area
        cell.viewController = viewController
        
        cell.areaLabel.text = area
        
        
        // area description
        // description
        var areaDescriptionText: String?
        switch area {
        case Constants.cga_functional:
            areaDescriptionText = FirebaseRemoteConfig.getStringFirebase(key: "cga_functional")
            break;
        case Constants.cga_afective:
            areaDescriptionText = FirebaseRemoteConfig.getStringFirebase(key:"cga_afective")
            break;
        case Constants.cga_nutritional:
            areaDescriptionText = FirebaseRemoteConfig.getStringFirebase(key:"cga_nutritional")
            break;
        case Constants.cga_cognitive:
            areaDescriptionText = FirebaseRemoteConfig.getStringFirebase(key:"cga_cognitive")
            break;
        case Constants.cga_march:
            areaDescriptionText = FirebaseRemoteConfig.getStringFirebase(key:"cga_march")
            break;
        default:
            areaDescriptionText = ""
        }
        
        cell.areaDescription.text = areaDescriptionText
        
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
