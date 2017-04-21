import UIKit
import FirebaseAuth
import FirebaseDatabase

class CGAPublicScalesQuestions: UITableViewController {
    
    // MARK: Constants
    
    var scale: GeriatricScale!
    
    let ViewQuestionChoicesSegue = "ViewQuestionChoices"
    
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        // set title
        self.title = scale.scaleName
        
        print("Single question? " + (scale.singleQuestion?.description)!)
    }
    
    // MARK: UITableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // get questions for scale
        return (scale.questions?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let question = scale.questions?[indexPath.row]
        
        cell.textLabel?.text = question?.descriptionText!
        cell.detailTextLabel?.text = question?.selectedChoice
        
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // perform Segue - go to patient's profile
        performSegue(withIdentifier: ViewQuestionChoicesSegue, sender: self)
    }

    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ViewQuestionChoicesSegue {
            
            let indexPath = tableView.indexPathForSelectedRow
            
            let question = scale.questions?[(indexPath?.row)!]
            let destinationViewController = segue.destination as! CGAPublicQuestionOptionsViewController
            // set the author
            destinationViewController.question = question
        }
    }
    
}
