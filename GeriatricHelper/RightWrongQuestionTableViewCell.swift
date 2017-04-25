//
//  RightWrongQuestionTableViewCell.swift
//  GeriatricHelper
//
//  Created by felgueiras on 25/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class RightWrongQuestionTableViewCell: UITableViewCell {
    
    var questionObj:Question?
    var scale:GeriatricScale?
    var category:QuestionCategory?

    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var wrongButton: UIButton!
    
    @IBAction func rightButtonClicked(_ sender: Any) {
        
        questionObj?.selectedRightWrong = "right"
//        yesButton.backgroundColor = UIColor.green
//        noButton.backgroundColor = UIColor(white: 1, alpha: 0.0)
        questionObj?.answered = true
        checkCategoryCompleted()
        checkScaleCompleted()
    }
    
    
    @IBAction func wrongButtonClicked(_ sender: Any) {
        
        questionObj?.selectedRightWrong = "wrong"
//        yesButton.backgroundColor = UIColor(white: 1, alpha: 0.0)
//        noButton.backgroundColor = UIColor.green
        questionObj?.answered = true
        checkCategoryCompleted()
//        checkScaleCompleted()
    }
    
    func checkCategoryCompleted()
    {
        // check all questions were answered
        var allQuestionsAnswered = true
        for question in (category?.questions)!{
            if question.answered != true{
                allQuestionsAnswered = false
                break
            }
        }
        
        if allQuestionsAnswered == true{
            print("All questions from this category were answered!")
//            scale?.completed = true
        }
    }
    
    func checkScaleCompleted()
    {
        // check all questions for every QuestionCategory
        var allQuestionsAnswered = true
        
        for questionCat in (scale?.questionsCategories)!{
            for question in questionCat.questions!{
                if question.answered != true{
                    allQuestionsAnswered = false
                    break
                }
            }
        }
        
        
        if allQuestionsAnswered == true{
            print("All questions answered!")
            scale?.completed = true
        }
    }
    
    static func createCell(cell: RightWrongQuestionTableViewCell,
                           question: Question,
                           scale:GeriatricScale,
                           category:QuestionCategory) -> UITableViewCell{
        
        cell.question.text = question.descriptionText!
        cell.questionObj = question
        cell.scale = scale
        cell.category = category
        
        
        return cell
        
    }
}
