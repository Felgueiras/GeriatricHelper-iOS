import UIKit
import FirebaseAuth
import FirebaseDatabase

// show all scales from CGA
//TODO - display scales organized by areas
class CGAScalesTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    
    // segue to display a patient's profile
    let SegueViewScaleSegue = "ViewScaleCGAGuide"
    
    
    
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
        
        // disable multiple selection
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        // get selected cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        // get the selected scale
        let sectionIndex = indexPath.section
        let area = Constants.cgaAreas[sectionIndex]
        let rowInsideSection = indexPath.row
        
        let scale = Constants.getScalesForArea(area: area)[rowInsideSection]
        
        // display popover
        let popOverVC = UIStoryboard(name: "PopOvers", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        
    
        let popover: UIPopoverPresentationController = popOverVC.popoverPresentationController!
//        popover.sourceView = cell
//        popover.sourceRect = cell.bounds
        
        popover.delegate = self
        
        popOverVC.scale = scale
        
        present(popOverVC, animated: true, completion:nil)
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.fullScreen
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
        let btnDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(CGAScalesTableViewController.dismiss as (CGAScalesTableViewController) -> () -> ()))
        navigationController.topViewController?.navigationItem.rightBarButtonItem = btnDone
        return navigationController
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
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
//        cell.detailTextLabel?.text = scale.area
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
            // perform Segue - view scale questions
            performSegue(withIdentifier: "ViewScaleQuestions", sender: self)
        }
        else{
            // single question scale - display the choices
            performSegue(withIdentifier: "SingleChoiceSegue", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewScaleQuestions" {
            
            let indexPath = tableView.indexPathForSelectedRow
            
            let sectionIndex = indexPath?.section
            let area = Constants.cgaAreas[sectionIndex!]
            let rowInsideSection = indexPath?.row
            
            let scale = Constants.getScalesForArea(area: area)[rowInsideSection!]
            
            let destinationViewController = segue.destination as! CGAScaleQuestionsTableViewController
            destinationViewController.scale = scale
            
            
        } else if segue.identifier == "SingleChoiceSegue" {
            
            let indexPath = tableView.indexPathForSelectedRow
            
            let sectionIndex = indexPath?.section
            let area = Constants.cgaAreas[sectionIndex!]
            let rowInsideSection = indexPath?.row
            
            let scale = Constants.getScalesForArea(area: area)[rowInsideSection!]
            
            let destinationViewController = segue.destination as! CGAGuideScaleSingleQuestionChoices
            destinationViewController.scale = scale
            
            
        }
        
    }
}
