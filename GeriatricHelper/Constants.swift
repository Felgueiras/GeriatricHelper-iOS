//
//  Constants.swift
//  GeriatricHelper
//
//  Created by felgueiras on 16/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import Foundation

class Constants{
    
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
    
    // CGA areas
    static let cgaAreas = [
        "Estado funcional",
        "Situação social",
        "Estado mental",
        "Estado nutricional"
    ]
    
    
    static var patientGender: String?
    
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
    
    
    //TODO get a scale by its name
    static func getScaleByName(scaleName: String) -> GeriatricScale?{
        for scale in self.scales{
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
    
    
    static func getScalesForAreaPublicSession(area: String) -> [GeriatricScale]{
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
