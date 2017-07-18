//
//  YesNoQuestionTableViewCell.swift
//  GeriatricHelper
//
//  Created by felgueiras on 24/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import SwiftMessages

class YesNoQuestionTableViewCell: UITableViewCell {

    var questionObj:Question?
    
    // synchronized with backend
    var backend:Bool?
    
    var scale:GeriatricScale?

    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        
        questionObj?.selectedYesNo = "yes"
        yesButton.backgroundColor = UIColor.green
        noButton.backgroundColor = UIColor(white: 1, alpha: 0.0)
        questionObj?.answered = true
        checkScaleCompleted()
        
        if backend == true {
            
            // update in backend
            questionObj?.ref?.setValue(questionObj?.toAnyObject())
        }
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        
        questionObj?.selectedYesNo = "no"
        yesButton.backgroundColor = UIColor(white: 1, alpha: 0.0)
        noButton.backgroundColor = UIColor.red
        questionObj?.answered = true
        checkScaleCompleted()
        
    }
    
    func checkScaleCompleted()
    {
        // check all questions were answered
        var allQuestionsAnswered = true
        for question in (scale?.questions!)!{
            if question.answered != true{
                allQuestionsAnswered = false
                break
            }
        }
        
        if allQuestionsAnswered == true{
            SwiftMessagesHelper.showMessage(type: Theme.info,
                                            text: StringHelper.allQuestionsAnswered)
            scale?.completed = true
        }
    }
    
    static func createCell(cell: YesNoQuestionTableViewCell,
                           question: Question,
                           scale: GeriatricScale,
                           backend:Bool) -> UITableViewCell{
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backend = backend
        
        
        
        let questionIndex = scale.questions!.index(of: question)
        cell.question.text = String(questionIndex!+1) + " - " + question.descriptionText!
        cell.questionObj = question
        cell.scale = scale
        
        
        // question already answered
        if question.answered == true {
            //            questionView.setBackgroundResource(R.color.question_answered);
            if question.selectedYesNo == "yes" {
                cell.yesButton.backgroundColor = UIColor.green
                
            } else {
                cell.noButton.backgroundColor = UIColor.red
            }
        }
        
        return cell
        
    }

}
