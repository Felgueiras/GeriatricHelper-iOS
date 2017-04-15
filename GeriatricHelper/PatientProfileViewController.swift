//
//  PatientProfileViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 14/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class PatientProfileViewController: UIViewController {
    
    //MARK: properties
    var patient: Patient!
    
    @IBOutlet weak var patientName: UILabel!
    
    // segue to display a patient's profile
    let ViewPatientSessions = "ViewPatientSessions"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // setup views to display patient's info
        patientName.text = patient.name
        
        // set title
        self.title = patient.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // cancel adding a new Patient
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    // prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ViewPatientSessions {
            let destinationViewController = segue.destination as! PatientSessionsTableViewController
            // set the author
            destinationViewController.patient = patient
            
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
