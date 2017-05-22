import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftMessages

class  CGAPublicScalesQuestions: UITableViewController {
    
    // MARK: Constants
    var scale: GeriatricScale!
    
    var opt1: String?
    
    // segue to display the choices for a questions
    let ViewQuestionChoicesSegue = "ViewQuestionChoices"
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title
        self.title = scale.scaleName
                
        if scale.questions?.count == 0{
            // add questions to scale
            addQuestionsToScale()
        }
        
    }
    
    // add questions to this scale
    func addQuestionsToScale(){
        // get questions from Constants
        let questionsNonDB = Constants.getQuestionsForScale(scaleName: scale.scaleName!)
       
        for currentQuestionNonDB in questionsNonDB{
            var question = Question()
            question.descriptionText = currentQuestionNonDB.descriptionText
//            question.(false);
            
            
            // create Choices
            var choicesNonDB: [Choice] = currentQuestionNonDB.choices!
            
            for currentChoiceNonDB in choicesNonDB {
                
                var choice = Choice()
                choice.descriptionText = currentChoiceNonDB.descriptionText
                choice.name = currentChoiceNonDB.name
                choice.score = currentChoiceNonDB.score
                choice.yes = currentChoiceNonDB.yes
                choice.no = currentChoiceNonDB.no
                
                question.choices?.append(choice)
                
                
            }
            
            self.scale.questions?.append(question)
            
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
            if scale.completed == nil{
                SwiftMessagesHelper.showMessage(type: Theme.info,
                                                text: StringHelper.allQuestionsAnswered)
            }
            scale.completed = true
            
            
        }
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
