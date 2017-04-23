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
    
    //MARK: views
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var birthDate: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var hospitalProcessNumber: UILabel!
    
    // choose between
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        
        // reload the data
        self.table.reloadData()
    }

    @IBAction func deletePatient(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete Patient",
                                      message: "Do you wish to delete this Patient's profile?",
                                      preferredStyle: .alert)
        
        
        // cancel the current session
        let saveAction = UIAlertAction(title: "Yes",
                                       style: .default) { _ in
                                        // delete patient from UserDefaults
                                        PatientsManagement.deletePatient(patient: self.patient)
                                        
                                        
                                        // go back to patients list
                                        
//                                        self.performSegue(withIdentifier: "CGAPublicCancelSegue", sender: self)
                                        
        }
        
        let cancelAction = UIAlertAction(title: "No",
                                         style: .default)
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        // change favoriteness
        patient.favorite = !patient.favorite!
        
        // update patient 
        PatientsManagement.updatePatient(patient: patient)
        
        // update icon
        setFavoriteIcon()
        
        print("Favorite button pressed")
        
    }
    
    func setFavoriteIcon(){
        if patient.favorite == true{
            // patient is favorite
            let image = UIImage(named: "Star Filled-50")
            favoriteButton.setBackgroundImage(image, for: .normal, barMetrics: .default)
            
        }
        else
        {
            let image = UIImage(named: "Star-50")
            favoriteButton.setBackgroundImage(image, for: .normal, barMetrics: .default)
        }
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
        
        //MARK: set patient's info
//        birthDate.text = patient
        address.text = patient.address
        hospitalProcessNumber.text = patient.processNumber
        
        // check if favorite, change icon
        if patient.favorite == true{
            
        }
        
        
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

