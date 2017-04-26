import UIKit
import FirebaseAuth
import FirebaseDatabase



// show all scales from CGA
//TODO - display scales organized by areas
class CGAPrivateMain: UITableViewController {
    
    
    
    let ViewScaleQuestionsSegue = "ViewScaleQuestions"
    
    var session: Session?
    var scales: [GeriatricScale]? = []
    
    
    
    // cancel public CGA session
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Cancel Session",
                                      message: "Do you wish to cancel this CGA Session?",
                                      preferredStyle: .alert)
        
        
        // cancel the current session
        let saveAction = UIAlertAction(title: "Yes",
                                       style: .default) { _ in
                                        
                                        // TODO erase scale and associated data
                    
                                        self.performSegue(withIdentifier: "unwindToPatientProfile", sender: self)
                                        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // get scales from session
        
        // observe - value event type = listen for every change in data in the DB
        FirebaseHelper.ref.child(FirebaseHelper.scalesReferencePath).queryOrdered(byChild: "sessionID").queryEqual(toValue: session?.guid!).observe(.value, with: { snapshot in
            var scalesFirebase: [GeriatricScale] = []

            for item in snapshot.children {
                let scale = GeriatricScale(snapshot: item as! FIRDataSnapshot)
                scalesFirebase.append(scale)
            }
            

            self.scales = scalesFirebase
            self.tableView.reloadData()
        })
        
        
        self.tableView.reloadData()
    }
    
    // number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if((scales?.count)!<12)
        {
            return 0
        }
        // current area
        let area = Constants.cgaAreas[section]
        // number of scales for current area
        
        return Constants.getScalesForArea(area: area).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ScaleTableViewCell", owner: self, options: nil)?.first as! ScaleTableViewCell
        
        // get scales for this area
        
        let selectedArea = Constants.cgaAreas[indexPath.section]
        
        
        
        let scale = Constants.getScalesForAreaFromSession(area: selectedArea, scales: scales!)[indexPath.row]
        return ScaleTableViewCell.createCell(cell: cell,
                                             scale: scale,
                                             viewController: self)
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // TODO return the height of the cell
        return 100
    }
    
    
    
    
    // select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get cell and selected scale
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        //        var selectedAreaIndex = segmentedControl.selectedSegmentIndex
        
        // filter scales by selected
        let scale = Constants.getScalesForAreaFromSession(area: Constants.cgaAreas[indexPath.section], scales: scales!)[indexPath.row]
        
        
        performSegue(withIdentifier: ViewScaleQuestionsSegue, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ViewScaleQuestionsSegue {
            // pass scale to the controller
            
            let selectedArea = Constants.cgaAreas[(tableView.indexPathForSelectedRow?.section)!]
            let selectedRow = (tableView.indexPathForSelectedRow?.row)!
            
            var scale = Constants.getScalesForAreaFromSession(area: selectedArea, scales: scales!)[selectedRow]
            
            
            let destinationViewController = segue.destination as! CGAPrivateQuestions
            // set the author
            destinationViewController.scale = scale
            
        }
       
    }
    
}
