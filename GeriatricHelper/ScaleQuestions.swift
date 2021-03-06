import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftMessages

class  ScaleQuestions: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Constants
    var scale: GeriatricScale!
    var session: Session!
    
    @IBOutlet weak var table: UITableView!
    var opt1: String?
    
    // segue to display the choices for a questions
    let ViewQuestionChoicesSegue = "ViewQuestionChoices"
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table delegates and data source
        self.table.dataSource = self
        self.table.delegate = self
        
        // disable save button when reviewing session
        if Constants.reviewingSession == true{
            self.navigationItem.rightBarButtonItem = nil
        }
        
        // set title
        self.title = scale.scaleName
        
        
        if session?.type == Session.sessionType.privateSession{
            if scale.alreadyOpened == false{
                // add questions only once
                addQuestionsToScale()
            }
            
            // update scale in Firebase
            scale.alreadyOpened = true
            FirebaseDatabaseHelper.updateScale(scale: scale);
        }
        else{
            if scale.questions?.count == 0{
                // add questions to scale
                addQuestionsToScale()
            }
        }
        
        
        
    }
    
    @IBOutlet weak var saveButton: UIButton!
    
    // add questions to this scale
    func addQuestionsToScale(){
        // get questions from Constants
        let questionsNonDB = Constants.getQuestionsForScale(scaleName: scale.scaleName!)
        
        // get scale definition
        let scaleDefinition = Constants.getScaleByName(scaleName: scale.scaleName!)
        
        for currentQuestionNonDB in questionsNonDB{
            
            // check if question is only for women
            if scaleDefinition?.scoring != nil {
                if scaleDefinition?.scoring!.differentMenWomen == true {
                    if Constants.patientGender == Constants.PatientGender.male {
                        if currentQuestionNonDB.onlyForWomen!{
                            continue
                        }
                    }
                }
            }
            
        
            
            let question = Question()
            question.descriptionText = currentQuestionNonDB.descriptionText
            //            question.(false);
            question.scaleID = scale.guid
            
            
            // create Choices
            let choicesNonDB: [Choice] = currentQuestionNonDB.choices!
            
            for currentChoiceNonDB in choicesNonDB {
                
                let choice = Choice()
                choice.descriptionText = currentChoiceNonDB.descriptionText
                choice.name = currentChoiceNonDB.name
                choice.score = currentChoiceNonDB.score
                choice.yes = currentChoiceNonDB.yes
                choice.no = currentChoiceNonDB.no
                
                question.choices?.append(choice)
            }
            
            self.scale.questions?.append(question)
            
            if session?.type == Session.sessionType.privateSession {
                FirebaseDatabaseHelper.createQuestion(question: question)
            }
            
        }
        
    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.table.reloadData()
        
        // check all questions were answered
        var allQuestionsAnswered = true
        
        var questionsToAnswer = 0
        
        if session != nil && session!.type == Session.sessionType.privateSession {
            for question in FirebaseDatabaseHelper.getQuestionsFromScale(scale: scale){
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
                
                
                FirebaseDatabaseHelper.updateScale(scale: scale)
                
                
            }
        }
        else{
            
            for question in scale.questions!{
                if question.answered != true{
                    allQuestionsAnswered = false
                    
                    // check how many left to answer
                    for quest in scale.questions!{
                        
                        if quest.answered == nil
                        {
                            questionsToAnswer += 1
                        }
                    }
                    let saveButtonTitle = SwiftMessagesHelper.saveScale + " (faltam " + String(questionsToAnswer) + " questões)"
                    saveButton.setTitle(saveButtonTitle, for: .normal)
                    break
                }
            }
            
            if allQuestionsAnswered == true{
                if scale.completed == nil{
                    SwiftMessagesHelper.showMessage(type: Theme.info,
                                                    text: StringHelper.allQuestionsAnswered)
                }
                scale.completed = true
                let saveButtonTitle = SwiftMessagesHelper.saveScale
                saveButton.setTitle(saveButtonTitle, for: .normal)
            }
        }
        
        // store session on defaults
        let defaults = UserDefaults.standard
        if(session != nil)
        {
            // store Cga public scales
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: session!)
            defaults.set(encodedData, forKey: Constants.lastSession)
            
            let encodedScales: Data = NSKeyedArchiver.archivedData(withRootObject: Constants.cgaPublicScales!)
            defaults.set(encodedScales, forKey: Constants.lastScales)
            
            defaults.synchronize()
            
        }
        
    }
    
    // MARK: UITableView Delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // get questions for scale
//        // check if different men women
//        if self.scale.scoring?.differentMenWomen == true{
//            if Constants.patientGender == Constants.PatientGender.male{
//                // check which questions are for men
//                
//                // get questions for scale
//                return (self.scale.getQuestionsMen().count)
//            }
//
//        }
//        // get questions for scale
        return (self.scale.questions?.count)!
        
//        return Constants.getQuestionsForScale(scaleName: scale.scaleName!).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
//        let questionConstant = Constants.getQuestionsForScale(scaleName: scale.scaleName!)[indexPath.row]
        var questionsToConsider:[Question] = self.scale.questions!
        
//        // check if different men women
//        if self.scale.scoring?.differentMenWomen == true{
//            if Constants.patientGender == Constants.PatientGender.male{
//                // check which questions are for men
//                
//                // get questions for scale
//                questionsToConsider =  self.scale.getQuestionsMen()
//            }
//        }
        
        
        
        
        let questionConstant = questionsToConsider[indexPath.row]
        
        cell.textLabel?.text = String(indexPath.row+1) + " -  " + questionConstant.descriptionText!
        if(questionConstant.answered == true)
        {
            cell.detailTextLabel?.text = "R: " + questionConstant.selectedChoice!
        }
        else{
           cell.detailTextLabel?.text = ""
        }
        
        
        
//        if indexPath.row % 2 == 0{
//            cell.backgroundColor = Constants.cellBackgroundColor
//        }
        
        
        // check if there is info from Firebase
        if session != nil && session!.type == Session.sessionType.privateSession {
            var questionDB:Question?
            let questions = FirebaseDatabaseHelper.getQuestionsFromScale(scale: scale)
            if indexPath.row < questions.count{
                let questionDB = questions[indexPath.row]
                if questionDB != nil && questionDB.answered == true {
                    cell.accessoryType = .checkmark
                }
            }
            
        }
        else
        {
            let question = questionsToConsider[indexPath.row]
            if question.answered == true{
//                cell.accessoryType = .checkmark
                cell.backgroundColor = Constants.questionAnswered
            }
            else
            {
//                cell.accessoryType = .none
            }
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        performSegue(withIdentifier: ViewQuestionChoicesSegue, sender: self)
        
        
    }
    
    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ViewQuestionChoicesSegue {
            let destinationViewController = segue.destination as! QuestionOptions
            
            let indexPath = self.table.indexPathForSelectedRow
            
            var questionDB:Question
            
            let questionNonDB = (self.scale.questions?[(indexPath?.row)!])!
            
            if session != nil && session!.type == Session.sessionType.privateSession {
                questionDB = FirebaseDatabaseHelper.getQuestionsFromScale(scale: scale)[(indexPath?.row)!]
                destinationViewController.questionNonDB = questionNonDB
                destinationViewController.questionDB = questionDB
            }
            else{
                destinationViewController.questionNonDB = questionNonDB
                destinationViewController.questionDB = questionNonDB
            }
            
        }
    }
}
