//
//  CGAPublicInfo.swift
//  GeriatricHelper
//
//  Created by felgueiras on 18/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class CGAPublicInfo: UIViewController {
    
    let StartPublicSessionSegue = "StartPublicSession"
    
    @IBOutlet weak var createSessionButton: UIButton!
    // MARK: Create CGA Session
    @IBAction func startPublicSessionButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: self.StartPublicSessionSegue, sender: self)        
        
    }
    
    // unwind segue
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        let radius = screenSize.height * 0.5
        createSessionButton.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
        
    }
    
    @IBAction func showHelpScreen(_ sender: Any) {
        // switch tab to help
        tabBarController?.selectedIndex = 2
    }
    
    
    /**
     
     Prepare for a segue
     **/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == StartPublicSessionSegue {
            
 
            
            // create a new Session
            createNewSession()
            // add Scales to the Session
            addScalesToSession()
            
            // pass Session to the destination controller
            let DestViewController = segue.destination as! UINavigationController
            let destinationViewController = DestViewController.topViewController as! CGAPublicAreas
            destinationViewController.session = Constants.cgaPublicSession
        }
        
    }
    
    /**
     Create a new CGA Session.
     **/
    func createNewSession() {
        
        // clear public data
        Constants.cgaPublicScales?.removeAll()
        Constants.cgaPublicQuestions?.removeAll()
        Constants.cgaPublicChoices?.removeAll()
        
        let time = NSDate()
        let calendar = NSCalendar.current
        //        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: time)
        //        let hour = components.hour
        //        let minutes = components.minute
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        var dateString = dateFormatter.string(from: time as Date)
        // save
        var session = Session()
        session.guid = dateString
        
        // set date
        //        Calendar now = Calendar.getInstance();
        //        int; year = now.get(Calendar.YEAR);
        //        int; month = now.get(Calendar.MONTH);
        //        int; day = now.get(Calendar.DAY_OF_MONTH);
        //        int; hour = now.get(Calendar.HOUR_OF_DAY);
        //        int; minutes = now.get(Calendar.MINUTE);
        //        session.setDate(DatesHandler.createCustomDate(year, month, day, hour, minute));
        //        session.setDate(time.getTime());
        //system.out.println("Session date is " + session.getDate());
        //        FirebaseHelper.createSession(session);
        
        
        // save the ID
        //        sharedPreferences.edit().putString(getString(R.string.saved_session_public), sessionID).apply();
        
        // save in constants
        Constants.cgaPublicSession = session
    }
    
    /**
     Add scales to the Session.
     **/
    func addScalesToSession() {
        // add every scale
        for testNonDB in Constants.scales {
            var scale = GeriatricScale()
//            scale.guid = session.guid + "-" + testNonDB.scaleName
            scale.scaleName = testNonDB.scaleName
//            scale.scaleName = testNonDB.scaleName
            scale.shortName = testNonDB.shortName
            scale.area = testNonDB.area
//            scale.s(testNonDB.getSubCategory());
//            scale.sessionID = session.guid
            scale.descriptionText = testNonDB.descriptionText
            scale.singleQuestion = testNonDB.singleQuestion
            scale.subCategory = testNonDB.subCategory
            
//            if testNonDB.scaleName == Constants.test_name_clock_drawing))
//            scale.setContainsPhoto(true);
//            if (testNonDB.getScaleName().equals(Constants.test_name_tinetti)|| testNonDB.getScaleName().equals(Constants.test_name_marchaHolden))
//            scale.setContainsVideo(true);
            
            scale.alreadyOpened = false
            
            Constants.cgaPublicScales?.append(scale)
            print(scale.scaleName)
            print(Constants.cgaPublicScales?.count)
        }
    }
    
}
