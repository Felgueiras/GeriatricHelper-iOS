import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftMessages

class CGAPublicYesNo: UITableViewController {
    
    // MARK: Constants
    var scale: GeriatricScale!
       var session: Session?
    
   
    
    // segue to display the choices for a questions
    let ViewQuestionChoicesSegue = "ViewQuestionChoices"
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable save button when reviewing session
        if Constants.reviewingSession == true{
            self.navigationItem.rightBarButtonItem = nil
        }
        
        // set title
        self.title = scale.scaleName
                
        if scale.questions?.count == 0{
            // add questions to scale
            addQuestionsToScale()
        }
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        // check if scale was completed
        if scale.completed == false || scale.completed == nil {
            // show alert
            let alert = UIAlertController(title: "Cancel Session",
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
    // add questions to this scale
    func addQuestionsToScale(){
        // get questions from Constants
        let questionsNonDB = Constants.getQuestionsForScale(scaleName: scale.scaleName!)
       
        for currentQuestionNonDB in questionsNonDB{
            var question = Question()
            question.descriptionText = currentQuestionNonDB.descriptionText
            
            self.scale.questions?.append(currentQuestionNonDB)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
        
        // check all questions were answered
        var allQuestionsAnswered = true
        for question in scale.questions!{
            if question.answered != true{
                allQuestionsAnswered = false
                break
            }
        }
        
        if allQuestionsAnswered == true{
            print("All questions answered!")
            scale.completed = true
        }
    }
    
    // MARK: UITableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // get questions for scale
        return (scale.questions?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = Bundle.main.loadNibNamed("YesNoQuestionTableViewCell", owner: self, options: nil)?.first as! YesNoQuestionTableViewCell
        
        return YesNoQuestionTableViewCell.createCell(cell: cell,
                                                     cellIndex: indexPath.row,
                                                          scale: scale,
                                                          backend: false,
                                                          table: self.tableView)
   
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // TODO return the height of the cell
        return 100
    }

}
