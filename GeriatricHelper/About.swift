//
//  HelpMain.swift
//  GeriatricHelper
//
//  Created by felgueiras on 25/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import FirebaseRemoteConfig

class About: UIViewController {
    
    @IBOutlet weak var appVersion: UILabel!
    @IBOutlet weak var aboutText: UITextView!
    
    @IBAction func openPDF(_ sender: Any) {
        if let url = NSURL(string: FirebaseRemoteConfig.getStringFirebase(key:"about_germi_pdf")){
            UIApplication.shared.openURL(url as URL)
        }
    }
    override func viewDidLoad() {
        // display app version
        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        
        appVersion.text = "Versão: " + version
        
        // load about info from Remote Config
        aboutText.text = FirebaseRemoteConfig.getStringFirebase(key:"about_info")
    }

    
}
