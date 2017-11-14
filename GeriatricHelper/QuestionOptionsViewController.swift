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

    
    // select a choice
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1 - get cell
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // 2 - get grocery item
        let selectedChoice = choices[indexPath.row]
 
        // go back
    }

    

    
}
