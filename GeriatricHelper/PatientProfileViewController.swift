//
//  PatientProfileViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 14/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PatientProfileViewController: UIViewController{
    
    //MARK: properties
    var patient: Patient!
    
    var sessions: [Session] = []
    var prescriptions: [Prescription] = []

    
    // segue to display a patient's profile
    let ViewPatientSessions = "ViewPatientSessions"
    let ViewSessionScales = "ViewSessionScales"
    
    // Firebase reference to database
    let ref = FIRDatabase.database().reference()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var user: User!

    
    // choose between
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        
        // reload the data
        self.table.reloadData()
    }
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    
        
        // set title
        self.title = patient.name
        
        // set delegate for sessions table
        self.table.delegate = self
        self.table.dataSource = self
        
        // load patient's sessions
            FIRAuth.auth()!.addStateDidChangeListener { auth, user in
                guard let user = user else { return }
                self.user = User(authData: user)
                
                // reference the user
                let userID = FIRAuth.auth()?.currentUser?.uid
                
                // get patient's sessions
                let sessionsRef = self.ref.child("users").child(userID!).child("sessions")
                sessionsRef.queryOrdered(byChild: "patientID")
                    .queryEqual(toValue: self.patient.guid).observe(.value, with: { snapshot in
                        self.sessions.removeAll()
                        for item in snapshot.children {
                            let session = Session(snapshot: item as! FIRDataSnapshot)
                            print(session)
                            self.sessions.append(session)
                            print(session.guid)
                        }
                        self.table.reloadData()
                        
                        // ...
                    }) { (error) in
                        print(error.localizedDescription)
                }
                
                // get patient's prescriptions
                let prescriptionsRef = self.ref.child("users").child(userID!).child("prescriptions")
                prescriptionsRef.queryOrdered(byChild: "patientID")
                    .queryEqual(toValue: self.patient.guid).observe(.value, with: { snapshot in
                        self.prescriptions.removeAll()
                        for item in snapshot.children {
                            let prescription = Prescription(snapshot: item as! FIRDataSnapshot)
                            self.prescriptions.append(prescription)
                            print("Adding prescription")
                        }
                        self.table.reloadData()
                        
                        // ...
                    }) { (error) in
                        print(error.localizedDescription)
                }

                
        }
        
        
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
        else if segue.identifier == ViewSessionScales {
            if let indexPath = self.table.indexPathForSelectedRow,
                let session = sessions[indexPath.row] as? Session  {
                let destinationViewController = segue.destination as! SessionScalesViewController
                // set the session
                destinationViewController.session = session
                print("Session guid is\(session.guid)")
            }
        }
    }
    
}

extension PatientProfileViewController: UITableViewDataSource, UITableViewDelegate  {
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var itemCount = 0
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            // sessions
            itemCount = self.sessions.count
        case 2:
            // prescriptions
            itemCount = self.prescriptions.count
        default:
            break
        }
        
        return itemCount
    }
    
    // get cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            // sessions
            let session = sessions[indexPath.row]
            
            //TODO: convert from timestamp to date
            var date = NSDate(timeIntervalSince1970: Double(session.date!))
            
            cell.textLabel?.text = String(describing: date)
            cell.detailTextLabel?.text = session.patientID
        case 2:
            // prescriptions
            let prescription = prescriptions[indexPath.row]
            
            cell.textLabel?.text = prescription.name
            cell.detailTextLabel?.text = prescription.notes
        default:
            break
        }
        
        
        
        
        return cell
    }

    
    
   

 
    
}

