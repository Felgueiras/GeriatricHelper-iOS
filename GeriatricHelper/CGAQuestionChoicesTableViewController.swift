import UIKit
import FirebaseAuth
import FirebaseDatabase

// show questions from a scale
class CGAQuestionChoicesTableViewController: UITableViewController {
    
    // MARK: Properties
    var question: Question?
    
    // selected choice
    var selectedChoice:Choice? {
        didSet {
            if let choice = selectedChoice  {
                selectedChoiceIndex = question?.choices?.index{$0 === choice}
            }
        }
    }
    var selectedChoiceIndex:Int?

    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable multiple selection
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    // MARK: UITableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // number of questions for this scale
        return (question?.choices?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let choice = question?.choices?[indexPath.row]
        
        cell.textLabel?.text = choice?.name
        cell.detailTextLabel?.text = choice?.descriptionText
        
        // highlight choice if selected
        if indexPath.row == selectedChoiceIndex
        {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // handle row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedChoiceIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedChoice = question?.choices?[indexPath.row]
        
        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    

}
