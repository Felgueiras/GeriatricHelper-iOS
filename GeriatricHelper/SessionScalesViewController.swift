import UIKit
import FirebaseAuth
import FirebaseDatabase

class SessionScalesViewController: UITableViewController {
    
    // MARK: Constants
    
    var session: Session!
    
    // MARK: Properties
    // scales
    var scales: [GeriatricScale] = []
    // logged in user
    var user: User!
    // Firebase reference to database
    let ref = FIRDatabase.database().reference()
    
    // segue to display a session's scales
    let ViewScaleQuestionsSegue = "ViewScaleQuestion"

    
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
            
            // scales node reference
            let scalesRef = self.ref.child("users").child(userID!).child("scales")
            
            // get session's scales
            scalesRef.queryOrdered(byChild: "sessionID")
                .queryEqual(toValue: self.session.guid).observe(.value, with: { snapshot in
                
                for item in snapshot.children {
                    // 4
                    let scale = GeriatricScale(snapshot: item as! FIRDataSnapshot)
                    self.scales.append(scale)
                    print(scale.guid)
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
        return scales.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let scale = scales[indexPath.row]
        
        cell.textLabel?.text = String(scale.scaleName)
        cell.detailTextLabel?.text = scale.area
        
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
            let groceryItem = scales[indexPath.row]
            groceryItem.ref?.removeValue()
        }
    }
    
    // select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1 - get cell
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // 2 - get grocery item
        let selectedPatient = scales[indexPath.row]
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
        if segue.identifier == ViewScaleQuestionsSegue {
            if let indexPath = tableView.indexPathForSelectedRow,
                let scale = scales[indexPath.row] as? GeriatricScale  {
                let destinationViewController = segue.destination as! ScalesQuestionsViewController
                // set the author
                destinationViewController.scale = scale
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

    
}
