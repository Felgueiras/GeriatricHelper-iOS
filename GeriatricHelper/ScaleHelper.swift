//
//  Constants.swift
//  GeriatricHelper
//
//  Created by felgueiras on 16/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import Foundation

class ScaleHelper{
    
    /**
     Generate (quantitative) result for a GeriatricScale.
     **/
    static func getQuantitativeResult(scale: GeriatricScale) -> String
    {
        
        // generate quantitative result
        SessionHelper.generateScaleResult(scale: scale)
        
        // quantitative result
        var quantitative:String = ""
        quantitative += String(describing: scale.result!)
        
        let testNonDB = Constants.getScaleByName(scaleName: scale.scaleName!)
        
        if testNonDB?.scoring != nil {
            if testNonDB?.scoring?.differentMenWomen == false{
                quantitative += " (" + String(describing: testNonDB!.scoring!.minScore!)
                quantitative += "-" + String(describing: testNonDB!.scoring!.maxScore!)
                quantitative += ")"
            } else {
                if Constants.patientGender == Constants.PatientGender.male {
                    quantitative += " (" + String(describing: testNonDB!.scoring!.minMen!)
                    quantitative += "-" + String(describing: testNonDB!.scoring!.maxMen!)
                    quantitative += ")"
                }
            }
        } else {
            quantitative = "";
        }
        return quantitative
        
    }
    
    static func getQualitativeResult(scale: GeriatricScale) -> String
    {
        if scale.scaleName == Constants.test_name_mini_mental_state {
            let scoring = Constants.getScaleByName(scaleName: scale.scaleName!)?.scoring
            for grading in scoring!.valuesBoth! {
                if grading.grade == Constants.EDUCATION_LEVEL{
                    
                    if scale.result! >= Double(grading.min!) {
                        return "Resultado dentro do esperado"
                    }
                    else{
                        return "Resultado abaixo do esperado"
                    }
                }
            }
        }
        
        var qualitative:String = ""
        let match = SessionHelper.getGradingForScale(scale: scale, gender: "male")
        if match != nil{
            qualitative =  String(describing: match!.grade!)
        }
        return qualitative
    }
    
    

    
}
