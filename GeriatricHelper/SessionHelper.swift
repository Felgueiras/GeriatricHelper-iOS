//
//  Constants.swift
//  GeriatricHelper
//
//  Created by felgueiras on 16/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import Foundation

class SessionHelper{
    
    /**
     Generate (quantitative) result for a GeriatricScale.
     **/
    static func generateScaleResult(scale: GeriatricScale)
    {
        
        var res: Double = 0
        
        
        let questionsFromTest = scale.questions
        
        if (scale.singleQuestion)! {
            //system.out.println("SINGLE");
            let scoring = Constants.getScaleByName(scaleName: scale.scaleName!)?.scoring
            
            let valuesBoth = scoring?.valuesBoth
            for grade in valuesBoth! {
                if grade.grade == scale.answer {
                    // result is double, score is String
                    scale.result = Double(grade.score!)
                    //                    this.save();
                    //                    return grade.score!
                }
            }
        }
            
            
        else {
            for question in questionsFromTest! {
                // in the Hamilton scale, only the first 17 questions make up the result
                //                if (testName.equals(Constants.test_name_hamilton) &&
                //                    questionsFromTest.indexOf(question) > 16)
                //                break;
                /**
                 * Yes/no Question
                 */
                if question.yesOrNo == true {
                    
                    if question.selectedYesNo == "yes" {
                        res += Double((question.choices?.first?.yes)!)
                    } else {
                        res += Double((question.choices?.first?.no)!)
                    }
                }
                    /**
                     * Right/ wrong question
                     */
                else if question.rightWrong == true {
                    if question.selectedRightWrong == "right"{
                        res += 1
                    }
                    
                }
                    /**
                     * Numerical question.
                     */
                    //                else if (question.isNumerical()) {
                    //                    //                    System.out.println("Numerical");
                    //                    //                    res += question.getAnswerNumber();
                    //                }
                    /**
                     * Multiple Choice Question
                     */
                else {
                    // get the selected Choice
                    let selectedChoice = question.selectedChoice
                    print("Selected choice was " + selectedChoice!)
                    //system.out.println("Selected choice " + selectedChoice);
                    let choices = question.choices
                    print("Choices for questions size is " + String(describing: choices?.count))
                    //system.out.println("size " + choices.size());
                    for c in choices! {
                        print("Choice name is " + c.name!)
                        if c.name == selectedChoice {
                            print("Found!" + c.name!)
                            //system.out.println(c.toString());
                            res += c.score!
                        }
                    }
                    
                }
            }
            
            // save result
            scale.result =  Double(res)
        }
        
        // global assessment
        if scale.scaleName == "Mini nutritional assessment - avaliação global"
        {
        
            // get "triagem" score
            let triagem = Constants.getScaleByNamePublicSession(scaleName: "Mini nutritional assessment - triagem")
            scale.result = scale.result! + (triagem?.result)!
            
        
        }
    }
    
    
    static func getGradingForScale(scale: GeriatricScale, gender: String) -> Grading? {
        
        generateScaleResult(scale: scale)
        var scoring = Constants.getScaleByName(scaleName: scale.scaleName!)?.scoring
        
     
        var match: Grading
        // check if it's different for men and women
        if scoring == nil{
            return nil
        }
        if (scoring?.differentMenWomen)! {
            if Constants.patientGender == Constants.PatientGender.male {
                match = scoring!.getGrading(testResult: scale.result!, gender: Constants.PatientGender.male)!
            } else {
                match = scoring!.getGrading(testResult: scale.result!, gender: Constants.PatientGender.female)!
            }
        } else {
            match = scoring!.getGrading(testResult: scale.result!, gender: Constants.PatientGender.sameBoth)!
        }
        return match;
    }
    
}
