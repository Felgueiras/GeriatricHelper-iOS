import UIKit
import FirebaseAuth
import FirebaseDatabase



// show all scales from CGA
//TODO - display scales organized by areas
class CGAScalesForArea: UITableViewController {
    
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
        
        // check session type
        if session!.type == Session.sessionType.privateSession {
            
            // private session
            FirebaseHelper.ref.child(FirebaseHelper.scalesReferencePath).queryOrdered(byChild: "sessionID").queryEqual(toValue: session?.guid!).observe(.value, with: { snapshot in
                var scalesFirebase: [GeriatricScale] = []
                
                for item in snapshot.children {
                    let scale = GeriatricScale(snapshot: item as! FIRDataSnapshot)
                    scalesFirebase.append(scale)
                }
                
                self.scales = scalesFirebase
                self.tableView.reloadData()
            })
        
        }
        else{
        // public session
            self.scales = Constants.cgaPublicScales
            self.tableView.reloadData()
        }
        
        self.tableView.reloadData()
        
        
    }
    
    // number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // number of scales for area
        return Constants.getScalesForArea(area: area!).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ScaleTableViewCell", owner: self, options: nil)?.first as! ScaleTableViewCell
        
        let rowInsideSection = indexPath.row
        let scalesForArea = Constants.getScalesForAreaFromSession(area: area!, scales: scales!)
        
        
        if rowInsideSection < scalesForArea.count {
            let scale = scalesForArea[rowInsideSection]
            return ScaleTableViewCell.createCell(cell: cell,
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
        let scale = Constants.getScalesForAreaFromSession(area: area!, scales: scales!)[indexPath.row]
        
        
        ////
        
        
//        if (scale.scaleName == Constants.test_name_mini_nutritional_assessment_global)) {
//            // TODO check if triagem is already answered
//            
//            GeriatricScaleFirebase triagem = FirebaseDatabaseHelper.getScaleFromSession(session,
//                                                                                        Constants.test_name_mini_nutritional_assessment_triagem)
//        }
   
        // get scale definition
        let scaleScoring = Constants.getScaleByName(scaleName: scale.scaleName!)?.scoring
        // TODO only ask once && Constants.patientGender != Constants.MALE && Constants.patientGender != Constants.FEMALE
        if scaleScoring?.differentMenWomen == true  {
            checkGender(scale: scale)
            return
            
        } else {
            openScale(scale:scale)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    
    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ViewScaleQuestionsSegue {
            // pass scale to the controller
            let scaleName = Constants.getScalesForArea(area: area!)[(tableView.indexPathForSelectedRow?.row)!].scaleName
            
            for scale in scales! {
                if scale.scaleName == scaleName{
                    let destinationViewController = segue.destination as! CGAPublicScalesQuestions
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
                    let destinationViewController = segue.destination as! CGAPublicMultipleCategories
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
    
    func checkGender(scale: GeriatricScale) {
        
        let alert = UIAlertController(title: "Género do Paciente",
                                      message: nil,
                                      preferredStyle: .alert)
        
        
        let male = UIAlertAction(title: "Masculino",
                                 style: .default) { _ in
                                    
                                    Constants.patientGender = "male"
                                    self.openScale(scale: scale)
                                    
                                    
        }
        
        let female = UIAlertAction(title: "Feminino",
                                   style: .default) { _ in
                                    
                                    Constants.patientGender = "female"
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
