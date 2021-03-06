//
//  RightWrongQuestionTableViewCell.swift
//  GeriatricHelper
//
//  Created by felgueiras on 25/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import FirebaseStorage
import SwiftMessages

class RightWrongQuestionTableViewCell: UITableViewCell {
    
    var questionObj:Question?
    var scale:GeriatricScale?
    var category:QuestionCategory?
    var categoryLabel: UILabel?
    var questionIndex:Int?
    var table:UITableView?
    
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
        
        scrollDown()
        
        
        
        
    }
    
    func scrollDown()
    {
        // scroll down to reveal next question
        var questionCount: Int = 0
        if scale!.multipleCategories! == true{
                for question in category!.questions!{
                        questionCount += 1
                }

        }
        else
        {
            questionCount = (scale!.questions?.count)!
        }
        print(questionIndex)
        print(questionCount)
        
        if (questionIndex!+1) < questionCount{
            let indexPath = IndexPath(row: questionIndex!+1, section: 0)
            
            // auto scroll down
            table?.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    @IBAction func wrongButtonClicked(_ sender: Any) {
        
        questionObj?.selectedRightWrong = "wrong"
        rightButton.setImage(UIImage(named: "right unselected"), for: .normal)
        wrongButton.setImage(UIImage(named: "wrong selected"), for: .normal)
        questionObj?.answered = true
        checkCategoryCompleted()
        checkScaleCompleted()
        
        scrollDown()
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
        var questionsToAnswer = 0
        
        // check all questions for every QuestionCategory
        var allQuestionsAnswered = true
        
        for questionCat in (scale?.questionsCategories)!{
            for question in questionCat.questions!{
                if question.answered != true{
                    allQuestionsAnswered = false
                    questionsToAnswer += 1
                }
            }
        }
        
        if allQuestionsAnswered == true{
            print("All questions answered!")
            if scale?.completed == nil{
                SwiftMessagesHelper.showMessage(type: Theme.info,
                                                text: StringHelper.allQuestionsAnswered)
            }
            scale?.completed = true
            
            let saveButtonTitle = SwiftMessagesHelper.saveScale
            viewController?.saveButton.setTitle(saveButtonTitle, for: .normal)
            
//            FirebaseDatabaseHelper.updateScale(scale: scale!)
        }
        else
        {
            let saveButtonTitle = SwiftMessagesHelper.saveScale + " (faltam " + String(questionsToAnswer) + " questões)"
            viewController?.saveButton.setTitle(saveButtonTitle, for: .normal)
        }
    }
    
    var viewController: QuestionCategoryViewController?
    
    static func createCell(cell: RightWrongQuestionTableViewCell,
                           cellIndex: Int,
                           scale:GeriatricScale,
                           category:QuestionCategory,
                           categoryLabel:UILabel,
                           viewController:QuestionCategoryViewController) -> UITableViewCell{
        
        cell.viewController = viewController
        cell.table = viewController.table
        cell.questionIndex = cellIndex
        let question = category.questions?[cellIndex]
        
        cell.question.text = String(cellIndex+1) + " - " + (question?.descriptionText!)!
        cell.questionObj = question
        cell.scale = scale
        cell.category = category
        cell.categoryLabel = categoryLabel
        
        // check if question already answered
        if question?.answered == true{
            if question?.selectedRightWrong == "right"
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
        
        if question?.image == nil{
            cell.questionImage.isHidden = true
        }
        
        cell.checkCategoryCompleted()
        
        return cell
        
    }
}
