import UIKit
import FirebaseAuth
import FirebaseDatabase


class CGAPrivateQuestions: UITableViewController {
    
    // MARK: Constants
    var scale: GeriatricScale!
    
    var questions:[Question]? = []
    
   
    
    // segue to display the choices for a questions
    let ViewQuestionChoicesSegue = "ViewQuestionChoices"
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title
        self.title = scale.scaleName
                
        if questions?.count == 0{
            // add questions to scale
            addQuestionsToScale()
        }
        
    }
    
    // add questions to this scale
    func addQuestionsToScale(){
        // get questions from Constants
        let questionsNonDB = Constants.getQuestionsForScale(scaleName: scale.scaleName!)
       
        for currentQuestionNonDB in questionsNonDB{
            var question = currentQuestionNonDB
            question.scaleID = scale.guid
            
            self.scale.questions?.append(currentQuestionNonDB)
            
            FirebaseDatabaseHelper.createQuestion(question: question)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // fetch questions from scale
        
        // observe - value event type = listen for every change in data in the DB
        FirebaseHelper.ref.child(FirebaseHelper.questionsReferencePath).queryOrdered(byChild: "scaleID").queryEqual(toValue: scale?.guid!).observe(.value, with: { snapshot in
            var questionsFirebase: [Question] = []
            
            for item in snapshot.children {
                let question = Question(snapshot: item as! FIRDataSnapshot)
                questionsFirebase.append(question)
            }
            
            
            self.questions = questionsFirebase
            self.tableView.reloadData()
        })
        
        
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
        if scale.singleQuestion!{
            // each cell will be a single choice
            let choices = Constants.getChoicesSingleQuestionScale(scaleName: self.scale.scaleName!)
            return choices.count
        }
        
        
        // get questions for scale
        return questions!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
         
        if scale.singleQuestion!{
            // single question scale - display the choices
            let question = questions?[indexPath.row]
            
            let cell = Bundle.main.loadNibNamed("QuestionChoiceTableViewCell", owner: self, options: nil)?.first as! QuestionChoiceTableViewCell
            
            return QuestionChoiceTableViewCell.createCell(cell: cell,
                                                         question: question!,
                                                         scale: scale,
                                                         backend: true)
            
        }
        else{
            
            if scale.multipleCategories == true {
                print("MULTIPLE")
//                performSegue(withIdentifier: ViewScaleMultipleCategoriesSegue, sender: self)
            }
                // multiple choice
            else if scale.questions?.first?.yesOrNo == true {
                
                let question = questions?[indexPath.row]
                
                let cell = Bundle.main.loadNibNamed("YesNoQuestionTableViewCell", owner: self, options: nil)?.first as! YesNoQuestionTableViewCell
                
                return YesNoQuestionTableViewCell.createCell(cell: cell,
                                                             question: question!,
                                                             scale: scale,
                                                             backend: true)
            }
                
            else
            {
                // "normal" multiple choice
//                performSegue(withIdentifier: ViewScaleQuestionsSegue, sender: self)
            }
            
        }
        
        return UITableViewCell()
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // handle single choice questions
        if scale.singleQuestion!{
            
            // get cell
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            
            // get choices
            let choices = Constants.getChoicesSingleQuestionScale(scaleName: self.scale.scaleName!)
            let selectedChoice = choices[indexPath.row]
            
            // update in Firebase
            
            scale.answer = selectedChoice.grade
            
            // TODO set numerical score
            //        scale.result = selectedChoice.score
            scale.completed = true
            
            
            print("Question answered")
        
        }
        
    }
    
}



