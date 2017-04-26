//
//  QuestionChoiceTableViewCell.swift
//  GeriatricHelper
//
//  Created by felgueiras on 26/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class QuestionChoiceTableViewCell: UITableViewCell {
    
    
    var questionObj:Question?
    
    // synchronized with backend
    var backend:Bool?
    
    var scale:GeriatricScale?
    
    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!

   
    
    static func createCell(cell: QuestionChoiceTableViewCell,
                           question: Question,
                           scale: GeriatricScale,
                           backend:Bool) -> UITableViewCell{
        
        
        cell.backend = backend
        cell.question.text = question.descriptionText!
        cell.questionObj = question
        cell.scale = scale
        
        // question already answered
        if question.answered == true {
            //            questionView.setBackgroundResource(R.color.question_answered);
            if question.selectedYesNo == "yes" {
                cell.yesButton.backgroundColor = UIColor.green
                
            } else {
                cell.noButton.backgroundColor = UIColor.green
            }
        }
        
        return cell
        
    }
    
}
