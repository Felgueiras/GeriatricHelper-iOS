import UIKit
import FirebaseAuth
import FirebaseDatabase
import Instructions



// show all scales from CGA
class CGAGuideScalesForArea: UITableViewController {
    
    let coachMarksController = CoachMarksController()

    @IBOutlet weak var finishSessionButton: UIBarButtonItem!
    
    let numCoachMarks = 4
    
    var area: String?
    
    var scales: [GeriatricScale]? = []
    
    // MARK: segues identifiers
    let ViewScaleQuestionsSegue = "ViewScaleQuestions"
    
    let ViewScaleYesNoSegue = "YesNoQuestion"
    let ViewScaleMultipleCategoriesSegue = "MultipleCategories"
    let ReviewPublicSession = "ReviewPublicSession"
    let ViewScaleSingleQuestionChoicesSegue = "CGAViewSingleQuestionChoices"
    
    // can be public or private
    var session: Session?
    
    
    
    // cancel public CGA session
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Cancel Session",
                                      message: "Do you wish to cancel this CGA Session?",
                                      preferredStyle: .alert)
        
        
        // cancel the current session
        let saveAction = UIAlertAction(title: "Yes",
                                       style: .default) { _ in
                                        
                                        self.performSegue(withIdentifier: "CGAPublicCancelSegue", sender: self)
                                        
        }
        
        let cancelAction = UIAlertAction(title: "No",
                                         style: .default)
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // finish (and review cga session)
    @IBAction func finishButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: StringHelper.finishSession,
                                      message: StringHelper.finishSessionQuestion,
                                      preferredStyle: .alert)
        
        
        // cancel the current session
        let saveAction = UIAlertAction(title: StringHelper.yes,
                                       style: .default) { _ in
                                        
                                        // remove all the uncompleted scales
                                        var completedScales: [GeriatricScale]? = []
                                        for scale in Constants.cgaPublicScales!{
                                            if scale.completed == true {
                                                completedScales?.append(scale)
                                            }
                                        }
                                        Constants.cgaPublicScales = completedScales
                                        self.performSegue(withIdentifier: self.ReviewPublicSession, sender: self)
                                        
        }
        
        let cancelAction = UIAlertAction(title: StringHelper.no,
                                         style: .default)
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
  
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title
        self.title = area

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       
        // public session
            self.scales = Constants.cgaPublicScales
            self.tableView.reloadData()
        
        
        self.tableView.reloadData()
        
        // TODO check user defaults
        if UserDefaults.standard.bool(forKey: "instructions") {
            startInstructions()
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.coachMarksController.stop(immediately: true)
    }
    
    func startInstructions() {
        self.coachMarksController.start(on: self)
    }
    
    // number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // number of scales for area
        return Constants.getScalesForArea(area: area!).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ScaleTableViewCell", owner: self, options: nil)?.first as! ScaleCardTableViewCell
        
        let rowInsideSection = indexPath.row
        let scalesForArea = Constants.getScalesForArea(area: area!)
        
        
        
        if rowInsideSection < scalesForArea.count {
            let scale = scalesForArea[rowInsideSection]
            return ScaleCardTableViewCell.createCell(cell: cell,
                                                 scale: scale,
                                                 viewController: self)
        }
        return cell        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // TODO return the height of the cell
        return 175
    }
    
    
    // select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // get cell and selected scale
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        // get selected scale
        let scale = Constants.getScalesForArea(area: area!)[indexPath.row]
        
   
        // check education level
        if scale.scaleName == Constants.test_name_mini_mental_state {
            
            checkEducationLevel(scale: scale)
            return
        }
        
        
        
        // get scale definition
        let scaleScoring = Constants.getScaleByName(scaleName: scale.scaleName!)?.scoring
        if scaleScoring?.differentMenWomen == true  {
            checkGender(scale: scale)
            return
            
        }
        openScale(scale:scale)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ViewScaleQuestionsSegue {
            // pass scale to the controller
            let scaleName = Constants.getScalesForArea(area: area!)[(tableView.indexPathForSelectedRow?.row)!].scaleName
            
            for scale in scales! {
                if scale.scaleName == scaleName{
                    let destinationViewController = segue.destination as! ScaleQuestions
                    // set the author
                    destinationViewController.scale = scale
                    destinationViewController.session = session
                }
            }
        }
            // single choice
        else if segue.identifier == ViewScaleSingleQuestionChoicesSegue {
            
            // pass scale to the controller
            let scaleName = Constants.getScalesForArea(area: area!)[(tableView.indexPathForSelectedRow?.row)!].scaleName
            
            for scale in scales! {
                if scale.scaleName == scaleName{
                    let destinationViewController = segue.destination as! CGAScaleSingleChoice
                    // set the author
                    destinationViewController.scale = scale
                    destinationViewController.session = session!
                }
            }
            
        }
        else if segue.identifier == ViewScaleYesNoSegue {
            
            // pass scale to the controller
            let scaleName = Constants.getScalesForArea(area: area!)[(tableView.indexPathForSelectedRow?.row)!].scaleName
            
            for scale in scales! {
                if scale.scaleName == scaleName{
                    let destinationViewController = segue.destination as! CGAPublicYesNo
                    // set the author
                    destinationViewController.scale = scale
                }
            }
            
        }
        else if segue.identifier == ViewScaleMultipleCategoriesSegue {
            
            // pass scale to the controller
            let scaleName = Constants.getScalesForArea(area: area!)[(tableView.indexPathForSelectedRow?.row)!].scaleName
            
            for scale in scales! {
                if scale.scaleName == scaleName{
                    let destinationViewController = segue.destination as! MultipleCategories
                    // set the author
                    destinationViewController.scale = scale
                }
            }
            
        }
        else if segue.identifier == ReviewPublicSession {
            
            var DestViewController = segue.destination as! UINavigationController
            let destinationViewController = DestViewController.topViewController as! ReviewSessionTableViewController
            
            
            // set the author
            destinationViewController.session = session
            destinationViewController.scales = scales
            
        }
    }
    
    /**
     Open a scale - performSegue
     **/
    func openScale(scale:GeriatricScale){
        
        // static scale definition
        let scaleDef = Constants.getScaleByName(scaleName: scale.scaleName!)!
    
        // single question scale - display the choices
        if scaleDef.singleQuestion!{
            performSegue(withIdentifier: ViewScaleSingleQuestionChoicesSegue, sender: self)
        }
        else{
            
            if scaleDef.multipleCategories == true {
                performSegue(withIdentifier: ViewScaleMultipleCategoriesSegue, sender: self)
            }
                // multiple choice
            else if scaleDef.questions?.first?.yesOrNo == true {
                // yes/no
                performSegue(withIdentifier: ViewScaleYesNoSegue, sender: self)
            }
                
            else
            {
                // "normal" multiple choice
                performSegue(withIdentifier: ViewScaleQuestionsSegue, sender: self)
            }
            
        }
    
    }
    
    func checkEducationLevel(scale: GeriatricScale) {
        

        
        let alert = UIAlertController(title: "Escolaridade do Paciente",
                                      message: nil,
                                      preferredStyle: .alert)
        
        
        let level1 = UIAlertAction(title: "Analfabeto",
                                 style: .default) { _ in
                                    Constants.EDUCATION_LEVEL = "Analfabetos";
                                    self.openScale(scale: scale)
                                    
                                    
        }
        
        let level2 = UIAlertAction(title: "1 a 11 anos de escolaridade",
                                   style: .default) { _ in
                                    Constants.EDUCATION_LEVEL = "1 a 11 anos de escolaridade";
                                    self.openScale(scale: scale)
                                    
        }
        
        let level3 = UIAlertAction(title: "Escolaridade superior a 11 anos",
                                   style: .default) { _ in
                                    
                                    Constants.EDUCATION_LEVEL = "Escolaridade superior a 11 anos"
                                    self.openScale(scale: scale)
                                    
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .cancel)
        
        
        
        
        alert.addAction(level1)
        alert.addAction(level2)
        alert.addAction(level3)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
  
    
    func checkGender(scale: GeriatricScale) {
        
        let alert = UIAlertController(title: "Género do Paciente",
                                      message: nil,
                                      preferredStyle: .alert)
        
        
        let male = UIAlertAction(title: "Masculino",
                                 style: .default) { _ in
                                    
                                    Constants.patientGender = Constants.PatientGender.male
                                    self.openScale(scale: scale)
                                    
                                    
        }
        
        let female = UIAlertAction(title: "Feminino",
                                   style: .default) { _ in
                                    
                                    Constants.patientGender = Constants.PatientGender.female
                                    self.openScale(scale: scale)
                                    
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .cancel)
        
        
        
        
        alert.addAction(male)
        alert.addAction(female)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
