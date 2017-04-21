import UIKit
import FirebaseAuth
import FirebaseDatabase

// show questions from a scale
//TODO : show choices when selecting question
class CGAScaleQuestionsTableViewController: UITableViewController {
    
    // MARK: Properties
    var scale: GeriatricScale?
    
    // segue to display a patient's profile
    let SegueViewQuestionChoices = "ViewQuestionChoicesGuide"

    
    /**
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
 **/
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable multiple selection
        tableView.allowsMultipleSelectionDuringEditing = false
        
        // set the title as the scale name
        self.title = scale?.scaleName!
    }
    
    // MARK: UITableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Inside \(scale?.scaleName), with\(scale?.questions?.count) questions")
        
        // number of questions for this scale
        return scale!.questions!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let question = scale!.questions?[indexPath.row]
        
        cell.textLabel?.text = question?.descriptionText
//        cell.detailTextLabel?.text = question?.description
        
        return cell
    }
    
    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueViewQuestionChoices {
            if let indexPath = tableView.indexPathForSelectedRow,
                let question = scale?.questions?[indexPath.row] as? Question  {
                let destinationViewController = segue.destination as! CGAQuestionChoicesTableViewController
                // set the author
                destinationViewController.question = question
            }
        }
    }

}
