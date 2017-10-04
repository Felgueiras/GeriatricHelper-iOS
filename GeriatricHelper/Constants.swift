//
//  Constants.swift
//  GeriatricHelper
//
//  Created by felgueiras on 16/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import Foundation
import UIKit

class Constants{
    
    static let test_name_mini_mental_state = "Mini mental state examination (Folstein)"
    static var EDUCATION_LEVEL: String?
    
    // scales
    static var scales: [GeriatricScale] = []
    
    // start criteria
    static var startCriteria: [StartCriteria] = []
    // stopp criteria
    static var stoppCriteria: [StoppCriteria] = []
    
    // current on-going public CGA Session
    static var cgaPublicSession: Session?
    
    static var cgaPublicScales: [GeriatricScale]? = []
    static var cgaPublicQuestions: [Question]? = []
    static var cgaPublicChoices: [Choice]? = []
    
    static let cga_functional: String = "Estado funcional"
    static let cga_afective: String = "Estado afectivo"
    static let cga_march: String = "Marcha"
    static let cga_cognitive: String = "Estado cognitivo"
    static let cga_nutritional: String = "Estado nutricional"
    
    static let MALE: String = "male"
    static let FEMALE: String = "female"
    
    // Color
    static let cellBackgroundColor: UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    
    // CGA areas
    static let cgaAreas = [
        cga_functional,
        cga_afective,
        cga_march,
        cga_cognitive,
        cga_nutritional
    ]
    
    enum PatientGender {
        case male
        case female
        case sameBoth
    }
    
    
    
    static var patientGender: PatientGender?
    
    // get the choices for a single question scale
    static func getChoicesSingleQuestionScale(scaleName: String) -> [Grading]{
        print("Scale name is " + scaleName)
        // get scale definition by its name
        let scale = getScaleByName(scaleName: scaleName)
        // get choices for this question
        print(scale?.scoring?.valuesBoth)
        // TODO check different men women
        return (scale!.scoring?.valuesBoth)!
    }
    
    
    // get questions for a scale
    static func getQuestionsForScale(scaleName: String) -> [Question]{
        // get scale definition by its name
        let scale = getScaleByName(scaleName: scaleName)
        // get choices for this question
        print(scale?.questions?.count)
        // TODO check different men women
        return (scale!.questions)!
    }
    
    static func getQuestionCategoriesForScale(scaleName: String) -> [QuestionCategory]{
        // get scale definition by its name
        let scale = getScaleByName(scaleName: scaleName)
        
        return (scale?.questionsCategories)!
    }
    
    
    // get a scale by its name
    static func getScaleByName(scaleName: String) -> GeriatricScale?{
        for scale in self.scales{
            if scale.scaleName == scaleName{
                return scale
            }
        }
        return nil
    }
    
    // get a scale by its name
    static func getScaleByNamePublicSession(scaleName: String) -> GeriatricScale?{
        for scale in self.cgaPublicScales!{
            if scale.scaleName == scaleName{
                return scale
            }
        }
        return nil
    }
    
    
    // get scales from an area
    static func getScalesForArea(area: String) -> [GeriatricScale]{
        var scalesForArea: [GeriatricScale] = []
        for scale in self.scales{
            if scale.area == area{
            scalesForArea.append(scale)
            }
        }
        
        return scalesForArea
    }
    
    /**
     Get public scales of a certain area.
    **/
    static func getScalesForAreaPublicSession(area: String) -> [GeriatricScale]{
        print("Area is " + area)
        var scalesForArea: [GeriatricScale] = []
        for scale in self.cgaPublicScales!{
            if scale.area == area{
                scalesForArea.append(scale)
            }
        }
        
        return scalesForArea
    }
    
    // get scales from an area for a Session
    static func getScalesForAreaFromSession(area: String, scales: [GeriatricScale]) -> [GeriatricScale]{
        var scalesForArea: [GeriatricScale] = []
        for scale in scales{
            if scale.area == area{
                scalesForArea.append(scale)
            }
        }
        
        return scalesForArea
    }
}
