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
        
        var testNonDB = Constants.getScaleByName(scaleName: scale.scaleName!)
        
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
        // TODO get correct gender
        var qualitative:String = ""
        let match = SessionHelper.getGradingForScale(scale: scale, gender: "male")
        if match != nil{
            qualitative =  String(describing: match!.grade!)
        }
        return qualitative
    }
    
    

    
}
