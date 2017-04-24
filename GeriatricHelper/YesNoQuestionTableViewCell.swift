//
//  YesNoQuestionTableViewCell.swift
//  GeriatricHelper
//
//  Created by felgueiras on 24/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class YesNoQuestionTableViewCell: UITableViewCell {


    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    
    
    static func createCell(cell: YesNoQuestionTableViewCell,
                           question: Question) -> UITableViewCell{
        
        
        
        cell.question.text = question.descriptionText!
        
        
        
        return cell
        
    }

}
