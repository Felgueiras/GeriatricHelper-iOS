//
//  FirebaseDatabaseHelper.swift
//  GeriatricHelper
//
//  Created by felgueiras on 26/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseRemoteConfig


class FirebaseRemoteConfig{
    
    static var remoteConfig: FIRRemoteConfig?
    
    

    func initRemoteConfig(){
        
//        self.remoteConfig = FIRRemoteConfig.remoteConfig()
        fetchCloudValues()
    }
    
    
    func fetchCloudValues() {
        // 1
        // WARNING: Don't actually do this in production!
        let fetchDuration: TimeInterval = 0
        FIRRemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) {
            [weak self] (status, error) in
            
            guard error == nil else {
                print ("Uh-oh. Got an error fetching remote values \(error)")
                return
            }
            
            // 2
            FIRRemoteConfig.remoteConfig().activateFetched()
            print ("Retrieved values from the cloud!")
        }
    }
    
    static func getStringFirebase(key: String) -> String{
        
        // replace /n for new line
        let str = FIRRemoteConfig.remoteConfig().configValue(forKey: key).stringValue!
        return str.replacingOccurrences(of: "\\n", with: "\n")
    }

}
