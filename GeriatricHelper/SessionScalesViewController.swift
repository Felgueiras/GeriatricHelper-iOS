import UIKit
import FirebaseAuth
import FirebaseDatabase

class SessionScalesViewController: UITableViewController {
    
    // MARK: Constants
    
    var session: Session!
    
    // MARK: Properties
    // scales
    var scales: [GeriatricScale] = []
    // logged in user
    var user: User!
    // Firebase reference to database
    let ref = FIRDatabase.database().reference()
    
    // segue to display a session's scales
    let ViewScaleQuestionsSegue = "ViewScaleQuestion"
    // display a single question scale's choices
    let ViewScaleSingleQuestionChoicesSegue = "ViewSingleQuestionChoices"
    
    @IBAction func changedArea(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        
        // add a state change listener - save the user
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            // reference the user
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            // scales node reference
            let scalesRef = self.ref.child("users").child(userID!).child("scales")
            
            // get session's scales
            scalesRef.queryOrdered(byChild: "sessionID")
                .queryEqual(toValue: self.session.guid).observe(.value, with: { snapshot in
                    self.scales.removeAll()
                    for item in snapshot.children {
                        // 4
                        let scale = GeriatricScale(snapshot: item as! FIRDataSnapshot)
                        self.scales.append(scale)
                    }
                    self.tableView.reloadData()
                    
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
            }
            
        }
    }
    
    
    // get scales from an area
    func getScalesForArea(area: String) -> [GeriatricScale]{
        var scalesForArea: [GeriatricScale] = []
        for scale in self.scales{
            if scale.area == area{
                scalesForArea.append(scale)
            }
        }
        
        return scalesForArea
    }
    
    // MARK: UITableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var itemCount = 0
        var selectedAreaIndex = segmentedControl.selectedSegmentIndex
        
        // filter scales by selected area
        return getScalesForArea(area: Constants.cgaAreas[selectedAreaIndex]).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        var selectedAreaIndex = segmentedControl.selectedSegmentIndex
        
        // filter scales by selected
        let scale = getScalesForArea(area: Constants.cgaAreas[selectedAreaIndex])[indexPath.row]
        
        cell.textLabel?.text = scale.scaleName!
        cell.detailTextLabel?.text = scale.area
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // remove from Firebase using reference
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // groceryItem is a Snapshot instance
            let groceryItem = scales[indexPath.row]
            groceryItem.ref?.removeValue()
        }
    }
    
    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var selectedAreaIndex = segmentedControl.selectedSegmentIndex
        
        // filter scales by selected
        let scale = getScalesForArea(area: Constants.cgaAreas[selectedAreaIndex])[(tableView.indexPathForSelectedRow?.row)!]
        
        
        if segue.identifier == ViewScaleQuestionsSegue {
            
            
            let destinationViewController = segue.destination as! ScalesQuestionsViewController
            // set the author
            destinationViewController.scale = scale
        }
        else if segue.identifier == ViewScaleSingleQuestionChoicesSegue {
            
            let destinationViewController = segue.destination as! ScaleSingleQuestionChoices
            // set the author
            destinationViewController.scale = scale
        }
    }
    
    
    // select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get cell and selected scale
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        var selectedAreaIndex = segmentedControl.selectedSegmentIndex
        
        // filter scales by selected
        let scale = getScalesForArea(area: Constants.cgaAreas[selectedAreaIndex])[indexPath.row]
        
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
    
}
