import UIKit
import FirebaseAuth
import FirebaseDatabase
import Instructions


// show all scales from CGA
class CGAGuideAreas: UITableViewController {
    
    let coachMarksController = CoachMarksController()
    
    var session: Session?
    
    let ViewAreaScales = "ViewAreaScales"
    
    let numCoachMarks = 3
    
    var scales:[GeriatricScale] = []
    
    @IBOutlet weak var finishScale: UIBarButtonItem!
    
    // cancel CGA session
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Cancelar Sessão",
                                      message: "Deseja cancelar esta sessão?",
                                      preferredStyle: .alert)
        
        
        // cancel the current session
        let saveAction = UIAlertAction(title: StringHelper.yes,
                                       style: .destructive) { _ in
                                        
                                        // check if user is logged in
                                        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
                                            if user == nil{
                                                // public
                                                self.performSegue(withIdentifier: "CGAPublicCancelSegue", sender: self)
                                            }
                                            else
                                            {
                                                // private
                                                self.performSegue(withIdentifier: "CGAPrivateCancelSegue", sender: self)
                                            }
                                            
                                        }
                                        
        }
        
        let cancelAction = UIAlertAction(title: StringHelper.no,
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
        let saveAction = UIAlertAction(title: "Sim",
                                       style: .default) { _ in
                                        
                                        // remove all the uncompleted scales
                                        var completedScales: [GeriatricScale]? = []
                                        for scale in Constants.cgaPublicScales!{
                                            if scale.completed == true {
                                                completedScales?.append(scale)
                                            }
                                        }
                                        
                                        Constants.cgaPublicScales = completedScales
                                        
                                        // if not one scale was completed
                                        if completedScales?.count == 0{
                                            self.performSegue(withIdentifier: "CGAPublicCancelSegue", sender: self)
                                        }
                                        
                                        self.performSegue(withIdentifier: "ReviewPublicSession", sender: self)
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Não",
                                         style: .default)
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sizable table cell
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.rowHeight = 180
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        // public session
        self.scales = Constants.cgaPublicScales!
        
        
        self.tableView.reloadData()
        
        
        // check user defaults
        if UserDefaults.standard.bool(forKey: "instructions") {
            startInstructions()
        }
        
    }
    
    // number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // number of CGA areas
        return Constants.cgaAreas.count
    }
    
    /**
     Load custom cell to display area,
     **/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("CGAGuideAreaTableViewCell", owner: self, options: nil)?.first as! CGAGuideAreaTableViewCell
        
        let area = Constants.cgaAreas[indexPath.row]
        

        
        return CGAGuideAreaTableViewCell.createCell(cell: cell,
                                               area: area,
                                               viewController: self)
        
        return cell
    }

    
    
    
    // select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get cell and selected scale
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        //        var selectedAreaIndex = segmentedControl.selectedSegmentIndex
        
        // filter scales by selected
        //        let scale = Constants.getScalesForArea(area: Constants.cgaAreas[indexPath.section])[indexPath.row]
        
        
        performSegue(withIdentifier: ViewAreaScales, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.coachMarksController.stop(immediately: true)
    }
    
    func startInstructions() {
        self.coachMarksController.start(on: self)
    }
    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == ViewAreaScales {
//            // pass area to the controller
//            let areaName = Constants.cgaAreas[(tableView.indexPathForSelectedRow?.row)!]
//
//
//            let destinationViewController = segue.destination as! CGAScalesForArea
//
//            // create session
//            destinationViewController.area = areaName
//            destinationViewController.session = session!
//        } else if segue.identifier == "ReviewPublicSession" {
//
//            var DestViewController = segue.destination as! UINavigationController
//            let destinationViewController = DestViewController.topViewController as! ReviewSessionTableViewController
//
//
//            // set the author
//            destinationViewController.session = session
//            destinationViewController.scales = scales
//
//        }
        
    }

    
}
