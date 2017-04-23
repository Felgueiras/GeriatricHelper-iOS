import UIKit
import FirebaseAuth
import FirebaseDatabase


/**
 Custom cell class for displaying the scale results
 **/

class ScaleCard: UITableViewCell {
    
    @IBOutlet weak var scaleName: UILabel!
    
    @IBOutlet weak var scaleResultQualitative: UILabel!
    
    @IBOutlet weak var scaleResultQuantitative: UILabel!
}

// show all scales from CGA
//TODO - display scales organized by areas
class CGAPublicMain: UITableViewController {
    
    
    
    let ViewScaleQuestionsSegue = "ViewScaleQuestions"
    
    let ViewScaleYesNoSegue = "YesNoQuestion"
    
    var session: Session?
    
    
    
    // segue to display a session's scales
    //    let ViewScaleQuestionsSegue = "ViewScaleQuestion"
    // display a single question scale's choices
    let ViewScaleSingleQuestionChoicesSegue = "CGAViewSingleQuestionChoices"
    
    
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
        let alert = UIAlertController(title: "Finish Session",
                                      message: "Do you wish to finish and review this CGA Session?",
                                      preferredStyle: .alert)
        
        
        // cancel the current session
        let saveAction = UIAlertAction(title: "Yes",
                                       style: .default) { _ in
                                        
                                        // remove all the uncompleted scales
                                        var completedScales: [GeriatricScale]? = []
                                        for scale in Constants.cgaPublicScales!{
                                            if scale.completed == true {
                                                completedScales?.append(scale)
                                            }
                                        }
                                        
                                        Constants.cgaPublicScales = completedScales
                                        
                                        self.performSegue(withIdentifier: "ReviewPublicSession", sender: self)
                                        
        }
        
        let cancelAction = UIAlertAction(title: "No",
                                         style: .default)
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.cgaAreas[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.cgaAreas.count
    }
    
    
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = Constants.cgaPublicSession
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
    }
    
    // number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // current area
        let area = Constants.cgaAreas[section]
        // number of scales for current area
        
        return Constants.getScalesForArea(area: area).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ScaleCard
        
        let sectionIndex = indexPath.section
        let area = Constants.cgaAreas[sectionIndex]
        let rowInsideSection = indexPath.row
        
        let scale = Constants.getScalesForAreaPublicSession(area: area)[rowInsideSection]
    
        cell.scaleName?.text = scale.scaleName
        
        if scale.completed == true{
            // generate quantitative result
            
            SessionHelper.generateScaleResult(scale: scale)
            
            cell.scaleResultQualitative?.text = ""
            cell.scaleResultQuantitative?.text = String(describing: scale.result)
        }
        else
        {
            
            cell.scaleResultQualitative?.text = ""
            cell.scaleResultQuantitative?.text = ""
        }
        
        
        return cell
    }
    
    
    // select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get cell and selected scale
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        //        var selectedAreaIndex = segmentedControl.selectedSegmentIndex
        
        // filter scales by selected
        let scale = Constants.getScalesForArea(area: Constants.cgaAreas[indexPath.section])[indexPath.row]
        
        if scale.singleQuestion!{
            // single question scale - display the choices
            performSegue(withIdentifier: ViewScaleSingleQuestionChoicesSegue, sender: self)
            
        }
        else{
            // multiple choice
            
            
            if scale.questions?.first?.yesOrNo == true {
                // yes/no
                // "normal" multiple choice
                performSegue(withIdentifier: ViewScaleYesNoSegue, sender: self)
            }
            else
            {
                // "normal" multiple choice
                performSegue(withIdentifier: ViewScaleQuestionsSegue, sender: self)
            }
            
            
            
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ViewScaleQuestionsSegue {
            // pass scale to the controller
            let scaleName = Constants.getScalesForArea(area: Constants.cgaAreas[(tableView.indexPathForSelectedRow?.section)!])[(tableView.indexPathForSelectedRow?.row)!].scaleName
            
            for scale in Constants.cgaPublicScales! {
                if scale.scaleName == scaleName{
                    let destinationViewController = segue.destination as! CGAPublicScalesQuestions
                    // set the author
                    destinationViewController.scale = scale
                }
            }
        }
        else if segue.identifier == ViewScaleSingleQuestionChoicesSegue {
            
            // pass scale to the controller
            let scaleName = Constants.getScalesForArea(area: Constants.cgaAreas[(tableView.indexPathForSelectedRow?.section)!])[(tableView.indexPathForSelectedRow?.row)!].scaleName
            
            for scale in Constants.cgaPublicScales! {
                if scale.scaleName == scaleName{
                    let destinationViewController = segue.destination as! CGAPublicScaleSingleChoice
                    // set the author
                    destinationViewController.scale = scale
                }
            }
            
        }
        else if segue.identifier == ViewScaleYesNoSegue {
            
            // pass scale to the controller
            let scaleName = Constants.getScalesForArea(area: Constants.cgaAreas[(tableView.indexPathForSelectedRow?.section)!])[(tableView.indexPathForSelectedRow?.row)!].scaleName
            
            for scale in Constants.cgaPublicScales! {
                if scale.scaleName == scaleName{
                    let destinationViewController = segue.destination as! CGAPublicYesNo
                    // set the author
                    destinationViewController.scale = scale
                }
            }
            
        }
    }
    
}
