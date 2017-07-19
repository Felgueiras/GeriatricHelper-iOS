import UIKit
import FirebaseAuth
import FirebaseDatabase
import Instructions



// show all scales from CGA
class CGAScalesForArea: UITableViewController, UIPopoverPresentationControllerDelegate {
    
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
        let saveAction = UIAlertAction(title: "Sim",
                                       style: .default) { _ in
                                        
                                        self.performSegue(withIdentifier: "CGAPublicCancelSegue", sender: self)
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Não",
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
        
        // handle Instructions
        self.coachMarksController.overlay.allowTap = true
        
        self.coachMarksController.dataSource = self
        
        // add BMI index calculator, preserving other buttons
        if area == Constants.cga_nutritional{
            let Nam1BarBtnVar = UIBarButtonItem(title: "IMC", style: .plain, target: self, action: #selector(CGAScalesForArea.Nam1BarBtnKlkFnc(_:)))
            
            self.navigationItem.setRightBarButtonItems([self.navigationItem.rightBarButtonItem!, Nam1BarBtnVar], animated: true)
        }
    }
    
    // open BMI calculator
    func Nam1BarBtnKlkFnc(_ sender : UIBarButtonItem)
    {
        // create popover
        let popOverVC = UIStoryboard(name: "PopOvers", bundle: nil).instantiateViewController(withIdentifier: "bmiCalculator") as! BMICalculatorPopUpViewController
        
        popOverVC.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover: UIPopoverPresentationController = popOverVC.popoverPresentationController!
        popover.barButtonItem = sender
        
        let minimumSize = self.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        popOverVC.preferredContentSize = CGSize(width: 280, height: 200)
        
        // center the popover
        
//        popover.sourceRect = CGRect(x:self.view.bounds.midX, y: self.view.bounds.midY,width: 315,height: 230)
        // remove arrows
//        controller?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        self.present(popOverVC, animated: true, completion:nil)
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
        
        // check user defaults
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
   
        // check education level
        if scale.scaleName == Constants.test_name_mini_mental_state {
            
            checkEducationLevel(scale: scale)
            return
        }
        
        
        
        // get scale definition
        let scaleScoring = Constants.getScaleByName(scaleName: scale.scaleName!)?.scoring
        // TODO only ask once && Constants.patientGender != Constants.MALE && Constants.patientGender != Constants.FEMALE
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
    
    let instructionsScaleIndex = 0
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}

// display Instructions
extension CGAScalesForArea: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    
    // whre to display the coach mark
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        var coachMarkView: UIView?
        
        let scale = Constants.getScalesForAreaFromSession(area: area!, scales: scales!)[instructionsScaleIndex]
        if scale.completed == true
        {
            switch index
            {
            case 0:
                let ndx = IndexPath(row:0, section: 0)
                let cell = self.tableView.cellForRow(at: ndx) as! ScaleTableViewCell
                coachMarkView = cell.resultQualitative
                
            case 1:
                // Info
                // get cell
                let ndx = IndexPath(row:0, section: 0)
                let cell = self.tableView.cellForRow(at: ndx) as! ScaleTableViewCell
                coachMarkView = cell.resultQuantitative
            case 2:
                coachMarkView = finishSessionButton.customView
            default:
                break
            }
        }
        else{
            
            switch index
            {
            case 0:
                // Escalas
                return coachMarksController.helper.makeCoachMark(for: self.navigationController?.navigationBar) { (frame: CGRect) -> UIBezierPath in
                    // This will make a cutoutPath matching the shape of
                    // the component (no padding, no rounded corners).
                    return UIBezierPath(rect: frame)
                }
            case 1:
                // Info
                // get cell
                let ndx = IndexPath(row:0, section: 0)
                let cell = self.tableView.cellForRow(at: ndx) as! ScaleTableViewCell
                coachMarkView = cell.infoButton
            case 2:
                // Notas
                // get cell
                let ndx = IndexPath(row:0, section: 0)
                let cell = self.tableView.cellForRow(at: ndx) as! ScaleTableViewCell
                coachMarkView = cell.notes
            case 3:
                // Escala
                // get cell
                let ndx = IndexPath(row:0, section: 0)
                let cell = self.tableView.cellForRow(at: ndx) as! ScaleTableViewCell
                coachMarkView = cell
            default:
                break
            }
        }
        
        
        return coachMarksController.helper.makeCoachMark(for: coachMarkView)
    }
    
    // number of coach marks
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        
        let scale = Constants.getScalesForAreaFromSession(area: area!, scales: scales!)[instructionsScaleIndex]
        if scale.completed == true
        {
            return 3
        }
        else{
            
            return numCoachMarks
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        let scale = Constants.getScalesForAreaFromSession(area: area!, scales: scales!)[instructionsScaleIndex]
        if scale.completed == true
        {
            switch index
            {
            case 0:
                // qualitativo
                coachViews.bodyView.hintLabel.text = "Resultado qualitativo"
                coachViews.bodyView.nextLabel.text = "Ok!"
            case 1:
                // quantitativo
                coachViews.bodyView.hintLabel.text = "Resultado quantitativo"
                coachViews.bodyView.nextLabel.text = "Ok!"
            case 2:
                // finish session
                coachViews.bodyView.hintLabel.text = "Depois de preencher as escalas que pretende, é altura de terminar a sessão. Clique aqui para terminar a sessão."
                coachViews.bodyView.nextLabel.text = "Ok!"
            default:
                break
            }
        }
        else{
            
            switch index
            {
            case 0:
                // Escalas
                coachViews.bodyView.hintLabel.text = "Dentro de cada área há várias escalas"
                coachViews.bodyView.nextLabel.text = "Ok!"
            case 1:
                // Info
                coachViews.bodyView.hintLabel.text = "Pode clicar aqui para aceder a informaçoes sobre uma escala"
                coachViews.bodyView.nextLabel.text = "Ok!"
            case 2:
                // Notas
                coachViews.bodyView.hintLabel.text = "Pode adicionar notas sobre uma escala"
                coachViews.bodyView.nextLabel.text = "Ok!"
            case 3:
                // Escala
                coachViews.bodyView.hintLabel.text = "Selecione esta escala e preencha-a, quando estiver completamente preenchida irá aparecer uma mensagem no ecrã"
                coachViews.bodyView.nextLabel.text = "Ok!"
            default:
                break
            }
        }
        
        
        
        
        
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
}
