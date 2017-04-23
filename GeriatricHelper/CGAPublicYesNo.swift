import UIKit
import FirebaseAuth
import FirebaseDatabase

class YesNoQuestionCard: UITableViewCell {
    
    var question: Question?
    
    var scale: GeriatricScale?
    
    
    @IBOutlet weak var questionLabel: UILabel!
    
    
    @IBOutlet weak var yesButton: UIButton!
    
   
 
    @IBOutlet weak var noButton: UIButton!
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        
        question?.selectedYesNo = "yes"
        yesButton.backgroundColor = UIColor.green
        noButton.backgroundColor = UIColor(white: 1, alpha: 0.0)
        question?.answered = true
        checkScaleCompleted()
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {

        question?.selectedYesNo = "no"
        yesButton.backgroundColor = UIColor(white: 1, alpha: 0.0)
        noButton.backgroundColor = UIColor.green
        question?.answered = true
        checkScaleCompleted()
        
    }
    
    func checkScaleCompleted()
    {
        // check all questions were answered
        var allQuestionsAnswered = true
        for question in (scale?.questions!)!{
            if question.answered != true{
                allQuestionsAnswered = false
                break
            }
        }
        
        if allQuestionsAnswered == true{
            print("All questions answered!")
            scale?.completed = true
        }
    }
}


class CGAPublicYesNo: UITableViewController {
    
    // MARK: Constants
    var scale: GeriatricScale!
    
   
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! YesNoQuestionCard
        let question = scale.questions?[indexPath.row]
        
        cell.questionLabel.text = question?.descriptionText
        
        cell.question = question
        
        cell.scale = scale
        
        /**
         * Question already answered.
         */
        if question?.answered == true {
            //            questionView.setBackgroundResource(R.color.question_answered);
            if question?.selectedYesNo == "yes" {
                cell.yesButton.backgroundColor = UIColor.green
                
            } else {
                cell.noButton.backgroundColor = UIColor.green
            }
        }
        
        return cell
    }

}
