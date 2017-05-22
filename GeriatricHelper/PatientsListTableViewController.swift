import UIKit
import FirebaseAuth
import FirebaseDatabase




class PatientsListTableViewController: UITableViewController {
    
    // MARK: Constants
    let listToUsers = "ListToUsers"
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentedControlSelectionChanged(_ sender: Any) {
        tableView.reloadData()
    }
    
    
    // MARK: Properties
    // patient
    var patients: [Patient] = []
    // logged in user
    var user: User!
    // number of online users
    var userCountBarButtonItem: UIBarButtonItem!
    // Firebase reference to database
    let ref = FIRDatabase.database().reference()
    
    // segue to display a patient's profile
    let SeguePatientViewController = "ViewPatientProfile"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredPatients = [Patient]()
    
    // set the title and icon for this tab
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Patients", image: UIImage(named: "PatientIcon"), tag: 0)
    }
    
    var favoritePatients: [Patient] = []
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.patients = PatientsManagement.getPatients()
        
        // get favorite patients
        favoritePatients.removeAll()
        for patient in self.patients{
            if patient.favorite == true{
                favoritePatients.append(patient)
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        userCountBarButtonItem = UIBarButtonItem(title: "1",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(userCountButtonDidTouch))
        userCountBarButtonItem.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = userCountBarButtonItem
        
        // add search bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        // add a state change listener - save the user
//        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
//            guard let user = user else { return }
//            self.user = User(authData: user)
//            
//            // reference the user
//            let userID = FIRAuth.auth()?.currentUser?.uid
//            
//            // get all patients
//            self.ref.child("users").child(userID!).child("patients").observe(.value, with: {snapshot in
//                // Get user value
//                let value = snapshot.value as? NSDictionary
//                let username = value?["name"] as? String ?? ""
//                
//                self.patients.removeAll()
//                
//                // 3
//                for item in snapshot.children {
//                    // 4
//                    let patient = Patient(snapshot: item as! FIRDataSnapshot)
//                    //                    print(patient)
//                    self.patients.append(patient)
//                }
//                self.tableView.reloadData()
//                
//                // ...
//            }) { (error) in
//                print(error.localizedDescription)
//            }
//            
//        }
    }
    
    // MARK: UITableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredPatients.count
        }
        
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            // all sessions
            return patients.count
        case 1:
            // favorite patients
            return favoritePatients.count
        default:
            break
        }
        
        return patients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let patient: Patient
        
        
         switch segmentedControl.selectedSegmentIndex
         {
         case 0:
            // all patients
            if searchController.isActive && searchController.searchBar.text != "" {
                patient = filteredPatients[indexPath.row]
            } else {
                patient = patients[indexPath.row]
            }
            cell.textLabel?.text = patient.name
         case 1:
            // favorite patients
            if searchController.isActive && searchController.searchBar.text != "" {
                patient = filteredPatients[indexPath.row]
            } else {
                patient = favoritePatients[indexPath.row]
            }
            cell.textLabel?.text = patient.name
         default:
            break
        }
        
        return cell
    }
    
    
    // remove from Firebase using reference
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // groceryItem is a Snapshot instance
            let groceryItem = patients[indexPath.row]
            groceryItem.ref?.removeValue()
        }
    }
    
    // select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1 - get cell
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // 2 - get grocery item
        let selectedPatient = patients[indexPath.row]
        // 3 - toogle ckmpletion
        //        let toggledCompletion = !groceryItem.favorite
        //        // 4 - update
        //        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        //        // 5 - tell Firebase "I updated my field called completed"
        //        groceryItem.ref?.updateChildValues([
        //            "completed": toggledCompletion
        //            ])
        
        //        // Perform Segue - go to patient's profile
                performSegue(withIdentifier: SeguePatientViewController, sender: self)
                tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguePatientViewController {
            
            let indexPath = tableView.indexPathForSelectedRow
            let patient: Patient
            if searchController.isActive && searchController.searchBar.text != "" {
                patient = filteredPatients[(indexPath?.row)!]
            } else {
                patient = patients[(indexPath?.row)!]
            }
            
            
            
            let destinationViewController = segue.destination as! PatientProfileViewController
            // set the author
            destinationViewController.patient = patient
            
        }
    }

    
    func userCountButtonDidTouch() {
        //        performSegue(withIdentifier: listToUsers, sender: nil)
        print("Touched something")
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPatients = patients.filter { patient in
            return (patient.name?.lowercased().contains(searchText.lowercased()))!
        }
        
        tableView.reloadData()
    }
    
}

// filter search results
extension PatientsListTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        
    }
    
}
