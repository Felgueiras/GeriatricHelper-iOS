import UIKit
import FirebaseAuth
import FirebaseDatabase
import Instructions


// show all scales from CGA
class CGAPublicAreas: UITableViewController {
    
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
        
        // handle Instructions
        self.coachMarksController.overlay.allowTap = true
        
        self.coachMarksController.dataSource = self
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
            self.scales = Constants.cgaPublicScales!
        }
        
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
        
        let cell = Bundle.main.loadNibNamed("CGAAreaTableViewCell", owner: self, options: nil)?.first as! CGAAreaTableViewCell
        let area = Constants.cgaAreas[indexPath.row]
        
        // get scales for area
        
        
        return CGAAreaTableViewCell.createCell(cell: cell,
                                               area: area,
                                               viewController: self,
                                               scales: Constants.getScalesForAreaFromSession(area: area, scales: scales))
        
        return cell
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
        
        if segue.identifier == ViewAreaScales {
            // pass area to the controller
            let areaName = Constants.cgaAreas[(tableView.indexPathForSelectedRow?.row)!]
            
            
            let destinationViewController = segue.destination as! CGAScalesForArea
            
            // create session
            destinationViewController.area = areaName
            destinationViewController.session = session!
        } else if segue.identifier == "ReviewPublicSession" {
            
            var DestViewController = segue.destination as! UINavigationController
            let destinationViewController = DestViewController.topViewController as! ReviewSessionTableViewController
            
            
            // set the author
            destinationViewController.session = session
            destinationViewController.scales = scales
            
        }
        
    }
    
    
    
}

// display Instructions
extension CGAPublicAreas: CoachMarksControllerDataSource, CoachMarksControllerDelegate {

    // whre to display the coach mark
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        var coachMarkView: UIView?
        
        switch index
        {
        case 0:
            // Áreas
            return coachMarksController.helper.makeCoachMark(for: self.navigationController?.navigationBar) { (frame: CGRect) -> UIBezierPath in
                // This will make a cutoutPath matching the shape of
                // the component (no padding, no rounded corners).
                return UIBezierPath(rect: frame)
            }
        case 1:
            // Info
            // get cell
            let ndx = IndexPath(row:1, section: 0)
            let cell = self.tableView.cellForRow(at: ndx) as! CGAAreaTableViewCell
            coachMarkView = cell.infoButton
        case 2:
            // Área
            // get cell
            let ndx = IndexPath(row:1, section: 0)
            let cell = self.tableView.cellForRow(at: ndx) as! CGAAreaTableViewCell
            coachMarkView = cell
        default:
            break
        }
        return coachMarksController.helper.makeCoachMark(for: coachMarkView)
    }
    
    // number of coach marks
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return numCoachMarks
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        switch index
        {
        case 0:
            // Áreas
            coachViews.bodyView.hintLabel.text = "A AGG encontra-se dividida por áreas"
            coachViews.bodyView.nextLabel.text = "Ok!"
        case 1:
            // Info
            coachViews.bodyView.hintLabel.text = "Pode clicar aqui para aceder a informaçoes sobre uma área"
            coachViews.bodyView.nextLabel.text = "Ok!"
        case 2:
            // Área
            coachViews.bodyView.hintLabel.text = "Clique aqui para selecionar esta área"
            coachViews.bodyView.nextLabel.text = "Ok!"
        default:
            break
        }
        
        
        
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
}
