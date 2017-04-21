import UIKit
import FirebaseAuth
import FirebaseDatabase

class PatientsListTableViewController: UITableViewController {
    
    // MARK: Constants
    let listToUsers = "ListToUsers"
    
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
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            // reference the user
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            // get all patients
            self.ref.child("users").child(userID!).child("patients").observe(.value, with: {snapshot in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let username = value?["name"] as? String ?? ""
                
                self.patients.removeAll()
                
                // 3
                for item in snapshot.children {
                    // 4
                    let patient = Patient(snapshot: item as! FIRDataSnapshot)
                    //                    print(patient)
                    self.patients.append(patient)
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredPatients.count
        }
        return patients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let patient: Patient
        
        
        
        
        if searchController.isActive && searchController.searchBar.text != "" {
            patient = filteredPatients[indexPath.row]
        } else {
            patient = patients[indexPath.row]
        }
        cell.textLabel?.text = patient.name
        return cell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
        //        performSegue(withIdentifier: SeguePatientViewController, sender: self)
        //        tableView.deselectRow(at: indexPath, animated: true)
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
    
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Grocery Item",
                                      message: "Add an Item",
                                      preferredStyle: .alert)
        
        
        // save an item to Firebase
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
                                        // 1 - get text
                                        guard let textField = alert.textFields?.first,
                                            let text = textField.text else { return }
                                        
                                        // 2 - create grocery item
                                        let groceryItem = GroceryItem(name: text,
                                                                      addedByUser: self.user.email,
                                                                      completed: false)
                                        // 3 - create reference to new child - key value is text in lowercase
                                        let groceryItemRef = self.ref.child(text.lowercased())
                                        
                                        // 4 - set value (save to firebase) - expects a dictionary,
                                        // GroceryItem has a method that turns it into a Dictionary
                                        groceryItemRef.setValue(groceryItem.toAnyObject())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func userCountButtonDidTouch() {
        //        performSegue(withIdentifier: listToUsers, sender: nil)
        print("Touched something")
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPatients = patients.filter { patient in
            return patient.name.lowercased().contains(searchText.lowercased())
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
