//
//  FirebaseHelper.swift
//  GeriatricHelper
//
//  Created by felgueiras on 25/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FirebaseHelper{
    
    

    static var userID:String?
    static var scales:[GeriatricScale] = []
    
    static let ref = FIRDatabase.database().reference()
    
    static let sessionsReferencePath = "users/" + String(describing: userID!) + "/sessions"
    static let prescriptionsReferencePath = "users/" + String(describing: userID!) + "/prescriptions"
    static let scalesReferencePath = "users/" + String(describing: userID!) + "/scales"
    static let questionsReferencePath = "users/" + String(describing: userID!) + "/questions"
}
