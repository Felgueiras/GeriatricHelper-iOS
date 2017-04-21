import UIKit
import FirebaseAuth
import FirebaseDatabase

class QuestionOptionsViewController: UITableViewController {
    
    // MARK: Constants
    
    var question: Question!
    
    // MARK: Properties
    // questions
    var choices: [Choice] = []
    // logged in user
    var user: User!
    // Firebase reference to database
    let ref = FIRDatabase.database().reference()
    
    // segue to display a session's questions
    let ViewSessionScalesSegue = "ViewSessionScales"

    
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
            
            // questions node reference
            let questionsRef = self.ref.child("users").child(userID!).child("questions")
            
//            // get scale by name
//            var scale = Constants.getScaleByName(scaleName: self.question.scale!.testName!)
//            
//            // get choices for this question (from Constants)
//            self.choices = self.question.choices!
            
        }
    }
    
    // MARK: UITableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let choice = choices[indexPath.row]
        
        cell.textLabel?.text = String(describing: choice.name)
        cell.detailTextLabel?.text = choice.description
        
//        toggleCellCheckbox(cell, isCompleted: patient.favorite)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    // remove from Firebase using reference
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // groceryItem is a Snapshot instance
//            let choice = choice[indexPath.row]
//            groceryItem.ref?.removeValue()
//        }
//    }
    
    // select a choice
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1 - get cell
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // 2 - get grocery item
        let selectedChoice = choices[indexPath.row]
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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == ViewSessionScalesSegue {
//            if let indexPath = tableView.indexPathForSelectedRow,
//                let patient = questions[indexPath.row] as? Patient  {
//                let destinationViewController = segue.destination as! PatientProfileViewController
//                // set the author
//                destinationViewController.patient = patient
//            }
//        }
//    }
    
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
