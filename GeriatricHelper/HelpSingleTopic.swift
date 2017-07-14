//
//  HelpMain.swift
//  GeriatricHelper
//
//  Created by felgueiras on 25/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import FirebaseRemoteConfig

class HelpSingleTopic: UIViewController {

    var helpTopic: String?
    
    var remoteConfig: FIRRemoteConfig?

    @IBOutlet weak var helpTopicText: UILabel!
    // MARK: - Table view data source
    
    func getStringFirebase(key: String) -> String{
        
        // replace /n for new line
        let str = FIRRemoteConfig.remoteConfig().configValue(forKey: key).stringValue!
        return str.replacingOccurrences(of: "\\n", with: "\n")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // access RemoteConfig
        self.remoteConfig = FIRRemoteConfig.remoteConfig()
        
        fetchCloudValues()
        
        var text: String?
        
        
        switch helpTopic! {
        case HelpTopics.help_topic_cga:
            text = getStringFirebase(key: "help_cga_description")
        case HelpTopics.help_topic_functionalities:
            text = getStringFirebase(key: "help_functionalitites_description")
        case HelpTopics.help_topic_personal_area:
            text = getStringFirebase(key: "help_personal_area")
        case HelpTopics.help_topic_patients:
            text = getStringFirebase(key: "help_patients_description")
        case HelpTopics.help_topic_prescriptions:
            text = getStringFirebase(key: "help_precription_description")
        case HelpTopics.help_topic_sessions:
            text = getStringFirebase(key: "help_sessions_description")
        case HelpTopics.help_topic_cga_guide:
            text = getStringFirebase(key: "help_cga_guide_description")
      
  
        case HelpTopics.help_topic_cga_guide:
            text = getStringFirebase(key: "help_cga_guide_description")
        case HelpTopics.help_topic_bibliography:
            text = getStringFirebase(key: "help_topic_bibliography_description")
        case HelpTopics.help_topic_cga_definition:
               text = getStringFirebase(key: "help_cga_definition")
        case HelpTopics.help_topic_cga_objective:
            text = getStringFirebase(key: "help_cga_objective")
        case HelpTopics.help_topic_cga_when:
            text = getStringFirebase(key: "help_cga_when")
        case HelpTopics.help_topic_cga_who:
            text = getStringFirebase(key: "help_cga_who")
        case HelpTopics.help_topic_cga_how:
            text = getStringFirebase(key: "help_cga_how")
        case HelpTopics.help_topic_cga_instruments:
            text = getStringFirebase(key: "help_cga_instruments")
        default:
            text = ""
        }
        helpTopicText.text = text
        print(text)
        
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

    

    
}
