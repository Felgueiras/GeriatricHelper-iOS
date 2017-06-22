import UIKit
import FirebaseAuth
import FirebaseDatabase

class ScalesQuestionsViewController: UITableViewController {
    
    // MARK: Constants
    
    var scale: GeriatricScale!
    
    // MARK: Properties
    // questions
    var questions: [Question] = []
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
        
        // set title
        self.title = scale.scaleName
        
        print("Single question? " + (scale.singleQuestion?.description)!)

        
        // add a state change listener - save the user
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            // reference the user
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            // questions node reference
            let questionsRef = self.ref.child("users").child(userID!).child("questions")
            
            // get session's questions
            questionsRef.queryOrdered(byChild: "scaleID")
                .queryEqual(toValue: self.scale.guid).observe(.value, with: { snapshot in
                
                for item in snapshot.children {
                    // 4
                    let question = Question(snapshot: item as! FIRDataSnapshot)
                    self.questions.append(question)
                    print(question)
                }
                self.tableView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }
    }
    
    // MARK: UITableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let question = questions[indexPath.row]
        
        cell.textLabel?.text = question.descriptionText!
        cell.detailTextLabel?.text = question.selectedChoice

        cell.accessoryType = .checkmark
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // remove from Firebase using reference
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // groceryItem is a Snapshot instance
            let groceryItem = questions[indexPath.row]
            groceryItem.ref?.removeValue()
        }
    }
    
    // select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1 - get cell
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // 2 - get grocery item
        let selectedPatient = questions[indexPath.row]
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
        if segue.identifier == ViewSessionScalesSegue {
            if let indexPath = tableView.indexPathForSelectedRow,
                let patient = questions[indexPath.row] as? Patient  {
                let destinationViewController = segue.destination as! PatientProfileViewController
                // set the author
                destinationViewController.patient = patient
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

    
}
