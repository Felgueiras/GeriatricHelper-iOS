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
    
    @IBAction func startPublicSessionButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: StartPublicSessionSegue, sender: self)
    }
    
    // unwind segue
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == StartPublicSessionSegue {
            
            // create a new Session
            
            // add Scales to the Session
            
            
            createNewSession()
            addScalesToSession()
            
            //            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
            //            builder.setTitle(R.string.select_patient_gender);
            //
            //            //list of items
            //            String[] items = new String[]{"M", "F"};
            //            builder.setSingleChoiceItems(items, 0,
            //            new DialogInterface.OnClickListener() {
            //            @Override
            //            public void onClick(DialogInterface dialog, int which) {
            //            // item selected logic
            //            if (which == 0)
            //            Constants.SESSION_GENDER = Constants.MALE;
            //            else
            //            Constants.SESSION_GENDER = Constants.FEMALE;
            //            }
            //            });
            //
            //
            //            String positiveText = getString(android.R.string.ok);
            //            builder.setPositiveButton(positiveText,
            //            new DialogInterface.OnClickListener() {
            //            @Override
            //            public void onClick(DialogInterface dialog, int which) {
            //            // positive button logic
            //            dialog.dismiss();
            //            }
            //            });
            //
            //
            //            builder.setCancelable(false);
            //            AlertDialog dialog = builder.create();
            //            // display dialog
            //            dialog.show();
            
            
            // pass Session to the destination controller
//            let destinationViewController = segue.destination as! CGAPublicMain
//            destinationViewController.session = Constants.cgaPublicSession
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
            if testNonDB.singleQuestion == true
            {
                scale.singleQuestion = true
            }
            
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
