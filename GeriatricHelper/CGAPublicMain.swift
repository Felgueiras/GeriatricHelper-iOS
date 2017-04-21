import UIKit
import FirebaseAuth
import FirebaseDatabase

// show all scales from CGA
//TODO - display scales organized by areas
class CGAPublicMain: UITableViewController {
    
    
    // segue to display a patient's profile
    let ViewScaleQuestionsSegue = "ViewScaleQuestions"
    
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
    
    // number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // current area
        let area = Constants.cgaAreas[section]
        // number of scales for current area
        
        return Constants.getScalesForArea(area: area).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let sectionIndex = indexPath.section
        let area = Constants.cgaAreas[sectionIndex]
        let rowInsideSection = indexPath.row
        
        let scale = Constants.getScalesForArea(area: area)[rowInsideSection]
        
        cell.textLabel?.text = scale.scaleName
        cell.detailTextLabel?.text = scale.area
        
        //        toggleCellCheckbox(cell, isCompleted: patient.favorite)
        
        return cell
    }
    

    
    //    // remove from Firebase using reference
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            // groceryItem is a Snapshot instance
    //            let groceryItem = patients[indexPath.row]
    //            groceryItem.ref?.removeValue()
    //        }
    //    }
    
    // select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get cell and selected scale
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        //        var selectedAreaIndex = segmentedControl.selectedSegmentIndex
        
        // filter scales by selected
        let scale = Constants.getScalesForArea(area: Constants.cgaAreas[indexPath.section])[indexPath.row]
        
        if !scale.singleQuestion!{
            // perform Segue - go to patient's profile
            performSegue(withIdentifier: ViewScaleQuestionsSegue, sender: self)
        }
        else{
            // single question scale - display the choices
            performSegue(withIdentifier: ViewScaleSingleQuestionChoicesSegue, sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ViewScaleQuestionsSegue {
            
            let scale = Constants.getScalesForArea(area: Constants.cgaAreas[(tableView.indexPathForSelectedRow?.section)!])[(tableView.indexPathForSelectedRow?.row)!]
            let destinationViewController = segue.destination as! CGAPublicScalesQuestions
            // set the author
            destinationViewController.scale = scale
        }
        else
            
            if segue.identifier == ViewScaleSingleQuestionChoicesSegue {
                
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
    }
    
}
