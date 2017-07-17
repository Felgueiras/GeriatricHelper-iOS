//
//  RightWrongQuestionTableViewCell.swift
//  GeriatricHelper
//
//  Created by felgueiras on 25/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import FirebaseStorage

class RightWrongQuestionTableViewCell: UITableViewCell {
    
    var questionObj:Question?
    var scale:GeriatricScale?
    var category:QuestionCategory?
    var categoryLabel: UILabel?
    
    @IBOutlet weak var questionImage: UIButton!
    
    @IBAction func displayQuestionImage(_ sender: Any) {
    }
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var wrongButton: UIButton!
    
    @IBAction func rightButtonClicked(_ sender: Any) {
        
        questionObj?.selectedRightWrong = "right"
        rightButton.setImage(UIImage(named: "right selected"), for: .normal)
        wrongButton.setImage(UIImage(named: "wrong unselected"), for: .normal)
        
        questionObj?.answered = true
        checkCategoryCompleted()
        checkScaleCompleted()
        
    }
    
    
    @IBAction func wrongButtonClicked(_ sender: Any) {
        
        questionObj?.selectedRightWrong = "wrong"
        rightButton.setImage(UIImage(named: "right unselected"), for: .normal)
        wrongButton.setImage(UIImage(named: "wrong selected"), for: .normal)
        questionObj?.answered = true
        checkCategoryCompleted()
        checkScaleCompleted()
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
            
            // highlight category name
            categoryLabel!.layer.backgroundColor = UIColor(red: 0/255, green: 100/255, blue: 0/255, alpha: 0.3).cgColor
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
                           category:QuestionCategory,
                           categoryLabel:UILabel) -> UITableViewCell{
        
        let questionIndex = category.questions!.index(of: question)
        cell.question.text = String(questionIndex!+1) + " - " + question.descriptionText!
        cell.questionObj = question
        cell.scale = scale
        cell.category = category
        cell.categoryLabel = categoryLabel
        
        // check if question already answered
        if question.answered == true{
            if question.selectedRightWrong == "right"
            {
                cell.rightButton.setImage(UIImage(named: "right selected"), for: .normal)
                cell.wrongButton.setImage(UIImage(named: "wrong unselected"), for: .normal)
            }
            else
            {
                cell.rightButton.setImage(UIImage(named: "right unselected"), for: .normal)
                cell.wrongButton.setImage(UIImage(named: "wrong selected"), for: .normal)
            }
            
            
        }
        
        if question.image == nil{
            cell.questionImage.isHidden = true
        }
        
        cell.checkCategoryCompleted()
        
        
        
        return cell
        
    }
}
