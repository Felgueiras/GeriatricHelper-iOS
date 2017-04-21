//
//  FavoritePatientCellCollectionViewCell.swift
//  GeriatricHelper
//
//  Created by felgueiras on 17/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class FavoritePatientCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var patientName: UILabel!
    
    var patient:Patient? {
        didSet {
            // update the UI
            patientName.text = patient?.name
            
        }
    }
    
}
