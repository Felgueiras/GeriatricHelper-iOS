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
    
    // MARK: segue identifiers
    let ConsultProgressSegue = "ConsultProgress"

    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    @IBAction func plusButtonClicked(_ sender: UIBarButtonItem) {
    
        // create an action sheet
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        
        // new session
        let newSession = UIAlertAction(title: "Nova Sessão",
                                 style: .default) { _ in
                                    
                    
                                    // create a new Session
                                    self.privateSession = self.createNewSession()
                                    // add Scales to the Session
                                    self.addScalesToSession(session: self.privateSession!)
                                    
                                    // navigate to private session
                                    
                                    self.performSegue(withIdentifier: "StartPrivateSession", sender: self)
                                    
        }
        
        // new prescription
        let newPrescription = UIAlertAction(title: "Adicionar Prescrição",
                                       style: .default) { _ in
                                        
                                        
//                                        // create a new Session
//                                        self.privateSession = self.createNewSession()
//                                        // add Scales to the Session
//                                        self.addScalesToSession(session: self.privateSession!)
//                                        
//                                        // navigate to private session
//                                        
                                        self.performSegue(withIdentifier: self.AddPrescription, sender: self)
                                        
        }
        
        // new session
        let consultProgress = UIAlertAction(title: "Consultar progresso",
                                       style: .default) { _ in
                                        
                                        self.performSegue(withIdentifier: self.ConsultProgressSegue, sender: self)
                                        
        }
        
 
        
        
        
        
        alert.addAction(newSession)
        alert.addAction(newPrescription)
        alert.addAction(consultProgress)
        
        alert.popoverPresentationController?.barButtonItem = sender
        
        present(alert, animated: true, completion: nil)
    }
   

    //MARK: Segues
    let ViewPatientSessions = "ViewPatientSessions"
    let ViewSessionScales = "ViewSessionScales"
    let AddPrescription = "AddPrescription"
    var user: User!

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
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
    
    var privateSession:Session?
    

    
    /**
     Create a new CGA Session.
     **/
    func createNewSession() -> Session {
        
        
        let time = NSDate()
        let calendar = NSCalendar.current
        //        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: time)
        //        let hour = components.hour
        //        let minutes = components.minute
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy hh:mm"
        var dateString = dateFormatter.string(from: time as Date)
        // save
        var session = Session()
        session.guid = dateString
        
        session.type = Session.sessionType.privateSession
        session.patientID = patient.guid
        
        let date = Date()
        session.date = date
        
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
        
        // save the ID
        //        sharedPreferences.edit().putString(getString(R.string.saved_session_public), sessionID).apply();
        
        // save Session
        FirebaseDatabaseHelper.createSession(session: session)
        
        
        // save in constants
        return session
    }
    
    /**
     Add scales to the Session.
     **/
    func addScalesToSession(session: Session) {
        // add every scale
        for testNonDB in Constants.scales {
            var scale = testNonDB
            scale.guid = session.guid! + "-" + testNonDB.scaleName!
            scale.sessionID = session.guid
            
            session.addScaleID(scaleID: scale.guid!)

            scale.scaleName = testNonDB.scaleName
            scale.shortName = testNonDB.shortName
            scale.area = testNonDB.area
            //            scale.s(testNonDB.getSubCategory());
            //            scale.sessionID = session.guid
            scale.descriptionText = testNonDB.descriptionText
            scale.singleQuestion = testNonDB.singleQuestion
            
            //            if testNonDB.scaleName == Constants.test_name_clock_drawing))
            //            scale.setContainsPhoto(true);
            //            if (testNonDB.getScaleName().equals(Constants.test_name_tinetti)|| testNonDB.getScaleName().equals(Constants.test_name_marchaHolden))
            //            scale.setContainsVideo(true);
            
            scale.alreadyOpened = false
            
            // TODO remove
            session.scales?.append(scale)
            // add scale to session
            FirebaseDatabaseHelper.createScale(scale:scale)
            
        }
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
//        birthDate.text = patient.birth2
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
                let sessionsRef = FirebaseHelper.ref.child("users").child(userID!).child("sessions")
                sessionsRef.queryOrdered(byChild: "patientID")
                    .queryEqual(toValue: self.patient.guid).observeSingleEvent(of: .value, with: { (snapshot) in
                        self.sessions.removeAll()
                        for item in snapshot.children {
                            let session = Session(snapshot: item as! FIRDataSnapshot)
                            self.sessions.append(session)
                        }
                        self.table.reloadData()
                        
                        // ...
                    }) { (error) in
                        print(error.localizedDescription)
                }
                
                // get patient's prescriptions
                let prescriptionsRef = FirebaseHelper.ref.child("users").child(userID!).child("prescriptions")
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
                destinationViewController.session = privateSession
                print("Session guid is\(session.guid)")
            }
        }
        else if segue.identifier == AddPrescription {
        
                let destinationViewController = segue.destination as! AddPrescriptionViewController
                // set the session
                destinationViewController.patient = patient
           
        }
        else if segue.identifier == "StartPrivateSession" {
            
            let destinationViewController = segue.destination as! CGAPublicAreas
            // set the session
            destinationViewController.session = privateSession
            
        }
        else if segue.identifier == ConsultProgressSegue {
            
            let destinationViewController = segue.destination as! ProgressTableViewController
            // set the session
            destinationViewController.sessions = sessions
        }
    }
    
    
    // unwind segue
    @IBAction func unwindToPatientProfile(segue: UIStoryboardSegue) {}

    
    
}

/**
 Display different sections.
 **/
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
        
    
        var cell:UITableViewCell?
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            cell = self.table.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
            // sessions
            let session = sessions[indexPath.row]
            
            
            
            cell?.textLabel?.text = DatesHandler.dateToStringWithoutHour(eventDate: session.date!)
            cell?.detailTextLabel?.text = session.patientID
        case 2:
            // load custom cell for Prescription
            cell = Bundle.main.loadNibNamed("PrescriptionTableViewCell", owner: self, options: nil)?.first as! PrescriptionTableViewCell
            
            // prescriptions
            let prescription = prescriptions[indexPath.row]
            
//            cell?.textLabel?.text = prescription.name
//            cell?.detailTextLabel?.text = prescription.notes
            
            return PrescriptionTableViewCell.createCell(cell: cell as! PrescriptionTableViewCell,
                                                   prescription: prescription,
                                                   viewController: self)
            
        default:
            break
        }
        
        
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // TODO return the height of the cell
        return 100
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    /**
     Remove a prescription.
     **/
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // remove from Firebase
            let prescription = prescriptions[indexPath.row]
            FirebaseDatabaseHelper.deletePrescription(prescription: prescription,
                                                      patient: patient)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
 
}

