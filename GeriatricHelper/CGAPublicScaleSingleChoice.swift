import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftMessages

class CGAPublicScaleSingleChoice: UITableViewController {
    
    // MARK: Constants
    
    var scale: GeriatricScale!
    
    // MARK: Properties
    var choices: [Grading] = []
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
        
        
        // get possible choices for single question scale
        self.choices = Constants.getChoicesSingleQuestionScale(scaleName: self.scale.scaleName!)
        self.tableView.reloadData()
        
    }
    
    // MARK: UITableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let currentGrading = choices[indexPath.row]
        
        cell.textLabel?.text = currentGrading.grade!
        cell.detailTextLabel?.text = currentGrading.descriptionText!
        
        // if this was the selected choice -> highlight
        if(scale.answer == currentGrading.grade){
            cell.accessoryType = .checkmark
        }
        
        
        return cell
    }
    
   
    
    
    // select a row - update in Firebase
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1 - get cell
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // 2 - get grocery item
        let selectedChoice = choices[indexPath.row]
        
        // update answer, result,
//        scale.ref?.updateChildValues([
//            "answer": selectedChoice.grade,
//            "result": selectedChoice.score
//            ])
        
        
        scale.answer = selectedChoice.grade

        // TODO set numerical score
//        scale.result = selectedChoice.score
        if scale.completed == nil{
            SwiftMessagesHelper.showMessage(type: Theme.info,
                                            text: StringHelper.allQuestionsAnswered)
        }
        scale.completed = true
        
        
        print("Question answered")

    }
    
    
}
