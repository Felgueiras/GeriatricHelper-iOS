import UIKit
import FirebaseAuth
import FirebaseDatabase

class PatientSessionsTableViewController: UITableViewController {
    
    // MARK: Constants
    let listToUsers = "ListToUsers"
    
    var patient: Patient!
    
    // MARK: Properties
    // patient
    var sessions: [Session] = []
    // logged in user
    var user: User!
    // number of online users
    var userCountBarButtonItem: UIBarButtonItem!
    // Firebase reference to database
    let ref = FIRDatabase.database().reference()
    
    // segue to display a session's scales
    let SeguePatientViewController = "ViewSessionScales"

    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false

        
        // add a state change listener - save the user
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            // reference the user
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            /**
             let patientsRef = self.ref.child("users").child(userID!).child("patients")
             // make query - retrieve favorite patients
             
             patientsRef.queryOrdered(byChild: "favorite").queryEqual(toValue: true) .observe(.value, with: { snapshot in
             // Get user value
             let value = snapshot.value as? NSDictionary
             let username = value?["name"] as? String ?? ""
             // let user = User.init(username: username)
             
             
             // 3
             for item in snapshot.children {
             // 4
             let patient = Patient(snapshot: item as! FIRDataSnapshot)
             //                    print(patient)
             self.patients.append(patient)
             }
             self.tableView.reloadData()
             
             })
 **/
            // sessions node reference
             let sessionsRef = self.ref.child("users").child(userID!).child("sessions")
            
            // get patient's sessions
            sessionsRef.queryOrdered(byChild: "patientID")
                .queryEqual(toValue: self.patient.guid).observe(.value, with: { snapshot in

                for item in snapshot.children {
                    let session = Session(snapshot: item as! FIRDataSnapshot)
                                        print(session)
                    self.sessions.append(session)
                    print(session.guid)
                }
                self.tableView.reloadData()
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }
    }
    
    // MARK: UITableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let session = sessions[indexPath.row]
        
        //TODO: convert from timestamp to date
        cell.textLabel?.text = String(describing: session.date)
        cell.detailTextLabel?.text = session.patientID
        
//        toggleCellCheckbox(cell, isCompleted: patient.favorite)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // remove from Firebase using reference
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // groceryItem is a Snapshot instance
            let groceryItem = sessions[indexPath.row]
            groceryItem.ref?.removeValue()
        }
    }
    
    // select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1 - get cell
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // 2 - get grocery item
        let selectedPatient = sessions[indexPath.row]
        // 3 - toogle ckmpletion
//        let toggledCompletion = !groceryItem.favorite
//        // 4 - update
//        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
//        // 5 - tell Firebase "I updated my field called completed"
//        groceryItem.ref?.updateChildValues([
//            "completed": toggledCompletion
//            ])
        
//        // Perform Segue - go to patient's profile
//        performSegue(withIdentifier: SeguePatientViewController, sender: self)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguePatientViewController {
            if let indexPath = tableView.indexPathForSelectedRow,
                let session = sessions[indexPath.row] as? Session  {
                let destinationViewController = segue.destination as! SessionScalesViewController
                // set the session
                destinationViewController.session = session
                print("Session guid is\(session.guid)")
            }
        }
    }
    
//    // changeUI depending on item being completed or not
//    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
//        if !isCompleted {
//            cell.accessoryType = .none
//            cell.textLabel?.textColor = UIColor.black
//            cell.detailTextLabel?.textColor = UIColor.black
//        } else {
//            cell.accessoryType = .checkmark
//            cell.textLabel?.textColor = UIColor.gray
//            cell.detailTextLabel?.textColor = UIColor.gray
//        }
//    }
    
    // MARK: Add Item
    
    
}
