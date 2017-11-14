import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftMessages

class CGAScaleSingleChoice: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: properties
    var scale: GeriatricScale!
    var session: Session?
    
    // MARK: Properties
    var choices: [Grading] = []
    // logged in user
    var user: User!
    // Firebase reference to database
    let ref = FIRDatabase.database().reference()
    
    // segue to display a session's questions
    let ViewSessionScalesSegue = "ViewSessionScales"
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        // check if scale was completed
        if scale.completed == false || scale.completed == nil {
            // show alert
            let alert = UIAlertController(title: SwiftMessagesHelper.saveScale,
                                          message: "Escala incompleta, continuar a preencher a escala?",
                                          preferredStyle: .alert)
            
            
            // cancel the current session
            let saveAction = UIAlertAction(title: "Sair da escala",
                                           style: .destructive) { _ in
                                            
                                            
                                            
                                            _ = self.navigationController?.popViewController(animated: true)
                                            //                                            self.performSegue(withIdentifier: "CGAPublicCancelSegue", sender: self)
                                            
            }
            
            let cancelAction = UIAlertAction(title: "Continuar",
                                             style: .default)
            
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
            
            
        }
        else{
            
            _ = self.navigationController?.popViewController(animated: true)
            SwiftMessagesHelper.showMessage(type: Theme.info,
                                            text: StringHelper.scaleSaved)
            
        }
        
    }
    
    @IBOutlet weak var table: UITableView!
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable save button when reviewing session
        if Constants.reviewingSession == true{
            self.navigationItem.rightBarButtonItem = nil
        }
        
        self.table.allowsMultipleSelectionDuringEditing = false
        
        // set title
        self.title = scale.scaleName
        
        
        // get possible choices for single question scale
        self.choices = Constants.getChoicesSingleQuestionScale(scaleName: self.scale.scaleName!)
        self.table.reloadData()
        
        // sizable table cell
        self.table.rowHeight = UITableViewAutomaticDimension
        self.table.estimatedRowHeight = 80
        
        // table data source and delegates
        self.table.delegate = self
        self.table.dataSource = self
        
    }
    
    // MARK: UITableView Delegate methods
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let currentGrading = choices[indexPath.row]
        
        cell.textLabel?.text = currentGrading.grade!
        cell.detailTextLabel?.text = currentGrading.descriptionText!
        
        // if this was the selected choice -> highlight
        if(scale.answer == currentGrading.grade){
             cell.backgroundColor = Constants.questionAnswered
        }
        else
        {
            cell.backgroundColor = UIColor.white
        }
        
        
//        if indexPath.row % 2 == 0{
//            cell.backgroundColor = Constants.cellBackgroundColor
//        }
        
        
        return cell
    }

    
    /**
     Choice was selected
     **/
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1 - get cell
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // 2 - get grocery item
        let selectedChoice = choices[indexPath.row]
        
        scale.answer = selectedChoice.grade
        scale.result = Double(selectedChoice.score!)

        if scale.completed == nil{
            SwiftMessagesHelper.showMessage(type: Theme.info,
                                            text: StringHelper.allQuestionsAnswered)
        }
        scale.completed = true
        
        if session?.type == Session.sessionType.privateSession{
            // update from Firebase
            // get grade
            let grading:Grading = choices[indexPath.row]
            scale.alreadyOpened = true
            scale.answer = grading.grade
            scale.completed = true
            
            // update scale
            FirebaseDatabaseHelper.updateScale(scale: scale);
        }
        
        tableView.reloadData()
    }
    
    
}
