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
    
    var table:UITableView?
    
    var questionIndex:Int?

    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        
        questionObj?.selectedYesNo = "yes"
        yesButton.backgroundColor = UIColor.green
        noButton.backgroundColor = UIColor(red: 129, green: 129, blue: 129, alpha: 1.0)
        questionObj?.answered = true
        checkScaleCompleted()
        
        if backend == true {
            
            // update in backend
            questionObj?.ref?.setValue(questionObj?.toAnyObject())
        }
        
        
        scrollDown()
        
        
    }
    
    func scrollDown()
    {
        // scroll down to reveal next question
        if questionIndex!+1 < (scale?.questions?.count)!{
            let indexPath = IndexPath(row: questionIndex!+1, section: 0)
            
            // auto scroll down
            table?.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
    
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        
        questionObj?.selectedYesNo = "no"
        yesButton.backgroundColor = UIColor(red: 129, green: 129, blue: 129, alpha: 1.0)
        noButton.backgroundColor = UIColor.red
        questionObj?.answered = true
        checkScaleCompleted()
        
        scrollDown()
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
                           cellIndex: Int,
                           scale: GeriatricScale,
                           backend:Bool,
                           table:UITableView) -> UITableViewCell{
        
        cell.questionIndex = cellIndex
         let question = scale.questions?[cellIndex]
        
        
        cell.table = table
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backend = backend
        
        
        
        let questionIndex = scale.questions!.index(of: question!)
        cell.question.text = String(questionIndex!+1) + " - " + (question?.descriptionText!)!
        cell.questionObj = question
        cell.scale = scale
        
        
        // question already answered
        if question?.answered == true {
            //            questionView.setBackgroundResource(R.color.question_answered);
            if question?.selectedYesNo == "yes" {
                cell.yesButton.backgroundColor = UIColor.green
                
            } else {
                cell.noButton.backgroundColor = UIColor.red
            }
        }
        
        return cell
        
    }

}
