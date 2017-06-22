import UIKit
import FirebaseAuth
import FirebaseDatabase

class CGAPublicQuestionOptionsViewController: UITableViewController {
    
    // MARK: Constants
    
    var questionDB: Question!
    var questionNonDB: Question!
    
    // MARK: Properties
    // questions
    var choices: [Choice] = []
    
    
    // selected choice
    var selectedChoice:Choice? {
        didSet {
            if let choice = selectedChoice  {
                selectedChoiceIndex = questionNonDB?.choices?.index{$0 === choice}
            }
        }
    }
    
    
    var selectedChoiceIndex:Int?
    
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        // get choices for this question
        self.choices = self.questionNonDB.choices!
        
        // set title
        self.title = self.questionNonDB.descriptionText!
        
    }
    
    // MARK: UITableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let choice = choices[indexPath.row]
        
        cell.textLabel?.text = String(describing: choice.name!)
        cell.detailTextLabel?.text = choice.descriptionText!
    
        // highlight choice if selected
        if indexPath.row == selectedChoiceIndex
        {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
    // select a choice
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1 - get cell
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
  
        selectedChoice = choices[indexPath.row]
        
        
        //Other row is selected - need to deselect it
        if let index = selectedChoiceIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        // save result
        
        questionDB.selectedChoice = selectedChoice?.name
        questionDB.answered = true
        

        //update the checkmark for the current row
        cell.accessoryType = .checkmark
        
        // update question
        FirebaseDatabaseHelper.updateQuestion(question: questionDB)
    }

    
}
