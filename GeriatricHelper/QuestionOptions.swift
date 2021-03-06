import UIKit
import FirebaseAuth
import FirebaseDatabase

class QuestionOptions: UITableViewController {
    
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
        
        // add gesture recognizer for long clicks
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(QuestionOptions.longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
//        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        
        // sizable table cell
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
    }
    
    // MARK: UITableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let choice = choices[indexPath.row]
        
        cell.textLabel?.text = String(describing: choice.name!)
        if choice.name! != choice.descriptionText!{
            cell.detailTextLabel?.text = choice.descriptionText!
        }
        else{
            cell.detailTextLabel?.text = ""
        }
        
        if questionDB.selectedChoice == choice.name{
            cell.backgroundColor = Constants.questionAnswered
        }
        
        
        // alternate shading
//        if indexPath.row % 2 == 0{
//            cell.backgroundColor = Constants.cellBackgroundColor
//        }

        
        return cell
    }
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint) {
                
                // your code here, get the row for the indexPath or do whatever you want
                print(indexPath.row)
            }
        }
        
    }
    
    
    // select a choice
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1 - get cell
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
  
        selectedChoice = choices[indexPath.row]
        
        // save result
        
        questionDB.selectedChoice = selectedChoice?.name
        questionDB.answered = true
        

        //update the color for the current row
//        cell.backgroundColor = Constants.questionAnswered
        
        // update question
        FirebaseDatabaseHelper.updateQuestion(question: questionDB)
        
        tableView.reloadData()
        
        // go back to questions list
        _ = self.navigationController?.popViewController(animated: true)
    }

    
}
