//
//  PrescriptionTableViewCell.swift
//  GeriatricHelper
//
//  Created by felgueiras on 21/05/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class PrescriptionTableViewCell: UITableViewCell {

  
    var prescription: Prescription?
    
    var viewController:UIViewController?
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var notes: UILabel!
    // create the cell
    static func createCell(cell: PrescriptionTableViewCell,
                           prescription: Prescription,
                           viewController: UIViewController) -> UITableViewCell{
        
        
        cell.prescription = prescription
        cell.viewController = viewController
        
        // set views
        cell.name.text = prescription.name
        cell.notes.text = prescription.notes
        
        // acess date
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: prescription.date!)
        let minute = calendar.component(.minute, from: prescription.date!)
        
        let day = calendar.component(.day, from: prescription.date!)
        let month = calendar.component(.month, from: prescription.date!)
        let year = calendar.component(.year, from: prescription.date!)
        
        cell.date.text = DatesHandler.dateToStringWithoutHour(eventDate: prescription.date!)
        return cell
        
    }
    
}
