import UIKit
import FirebaseAuth
import FirebaseDatabase

// show all criteria from CGA
//TODO fetch beers criteria
class PrescriptionsAllTableViewController: UITableViewController {

    
    // segue to display a patient's profile
//    let SegueViewScaleSegue = "ViewScaleCGAGuide"
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable multiple selection
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    // number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.startCriteria.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let criteria = Constants.startCriteria[indexPath.row]
        
        cell.textLabel?.text = criteria.category
//        cell.detailTextLabel?.text = criteria.area
        
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
        let selectedScale = Constants.scales[indexPath.row]

        
//        // Perform Segue - go to patient's profile
//        performSegue(withIdentifier: SeguePatientViewController, sender: self)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    // prepare for the segue
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == SegueViewScaleSegue {
//            if let indexPath = tableView.indexPathForSelectedRow,
//                let scale = Constants.scales[indexPath.row] as? GeriatricScale  {
//                let destinationViewController = segue.destination as! CGAScaleQuestionsTableViewController
//                destinationViewController.scale = scale
//            }
//        }
//    }
    
}
