import UIKit
import FirebaseAuth
import FirebaseDatabase
import FSCalendar

class SessionsTableViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    // MARK: Constants
    let listToUsers = "ListToUsers"
    
    var patient: Patient!
    
    // current selected date
    var currentDate: Date?
    
    // MARK: Properties
    // patient
    var sessions: [Session] = []
    // logged in user
    var user: User!
    // number of online users
    var userCountBarButtonItem: UIBarButtonItem!
    // Firebase reference to database
    let ref = FIRDatabase.database().reference()
    
    // segue to display a session's scales
    let SeguePatientViewController = "ViewSessionScales"

    /**
     Create a new Session.
     **/
    @IBAction func createSession(_ sender: UIBarButtonItem) {
        
        // create an action sheet
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        
        let withPatient = UIAlertAction(title: "Nova Sessão com Paciente",
                                       style: .default) { _ in
                                        
                                        
//                                        // create a new Session
//                                        self.privateSession = self.createNewSession()
//                                        // add Scales to the Session
//                                        self.addScalesToSession(session: self.privateSession!)
//                                        
//                                        // navigate to private session
//                                        
//                                        self.performSegue(withIdentifier: "StartPrivateSession", sender: self)
                                        
        }
        
        // new prescription
        let withoutPatient = UIAlertAction(title: "Sem Paciente",
                                            style: .default) { _ in
                                                
                                           
                                                
        }
        

        
        
        
        
        alert.addAction(withPatient)
        alert.addAction(withoutPatient)
        
        alert.popoverPresentationController?.barButtonItem = sender
        
        present(alert, animated: true, completion: nil)

    }
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelectionDuringEditing = false

        
        // add a state change listener - save the user
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            // reference the user
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            // sessions node reference
             let sessionsRef = self.ref.child("users").child(userID!).child("sessions")
            
            // get every session
            sessionsRef.observe(.value, with: { snapshot in

                for item in snapshot.children {
                    let session = Session(snapshot: item as! FIRDataSnapshot)
                                        print(session)
                    self.sessions.append(session)
                    self.calendar.reloadData()
                }
                self.tableView.reloadData()
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }
        
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
        
        self.currentDate = Date()
        
        
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
    }
    
    var sessionDates:[Date] = []
    
    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguePatientViewController {
            if let indexPath = tableView.indexPathForSelectedRow,
                let session = sessions[indexPath.row] as? Session  {
                let destinationViewController = segue.destination as! SessionScalesViewController
                // set the session
                destinationViewController.session = session
                print("Session guid is\(session.guid)")
            }
        }
    }
    
    // MARK: Add Item
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
//        let alert = UIAlertController(title: "Grocery Item",
//                                      message: "Add an Item",
//                                      preferredStyle: .alert)
//        
//        
//        // save an item to Firebase
//        let saveAction = UIAlertAction(title: "Save",
//                                       style: .default) { _ in
//                                        // 1 - get text
//                                        guard let textField = alert.textFields?.first,
//                                            let text = textField.text else { return }
//                                        
//                                        // 2 - create grocery item
//                                        let groceryItem = GroceryItem(name: text,
//                                                                      addedByUser: self.user.email,
//                                                                      completed: false)
//                                        // 3 - create reference to new child - key value is text in lowercase
//                                        let groceryItemRef = self.ref.child(text.lowercased())
//                                        
//                                        // 4 - set value (save to firebase) - expects a dictionary,
//                                        // GroceryItem has a method that turns it into a Dictionary
//                                        groceryItemRef.setValue(groceryItem.toAnyObject())
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel",
//                                         style: .default)
//        
//        alert.addTextField()
//        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true, completion: nil)
    }
    
    
    /**
     Get sessions from a day.
 **/
    func fetchSessionsFromDay(date:Date) -> [Session]{
        
        print("Fetching sessions from\(date)")
        
        var sessionsFromDate:[Session] = []
        
        let day: Int! = self.gregorian.component(.day, from: date)
        let month: Int! = self.gregorian.component(.month, from: date)
        let year: Int! = self.gregorian.component(.year, from: date)
        
        // check if there are sessions for that day
        for session in self.sessions{
            
            let sessionDate = session.date!
            let daySession: Int! = self.gregorian.component(.day, from: sessionDate)
            let monthSession: Int! = self.gregorian.component(.month, from: sessionDate)
            let yearSession: Int! = self.gregorian.component(.year, from: sessionDate)
            
            
            
            
            if daySession == day && monthSession == month && yearSession == year
            {
                sessionsFromDate.append(session)
            }
        }

        
        return sessionsFromDate
        
    }
    
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
//        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    deinit {
        print("\(#function)")
    }
    
    fileprivate var lunar: Bool = false {
        didSet {
            self.calendar.reloadData()
        }
    }
    
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    /**
     Handle date selection.
     **/
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        // update current date
        self.currentDate = date
        
        // reload table data
        self.tableView.reloadData()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)

    
    
    /**
     Title
     **/
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        //        return self.gregorian.isDateInToday(date) ? "Hoje" : nil
        return nil
    }
    
    /**
     Subtitle
     **/
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        //        return "123"
        return nil
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2017/10/30")!
    }
    
    /**
     Visual subtitle - number of dots (max is 3)
     **/
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        

        let day: Int! = self.gregorian.component(.day, from: date)
        let month: Int! = self.gregorian.component(.month, from: date)
        let year: Int! = self.gregorian.component(.year, from: date)
        
        // check if there are sessions for that day
        for session in self.sessions{
            
            let sessionDate = session.date!
            let daySession: Int! = self.gregorian.component(.day, from: sessionDate)
            let monthSession: Int! = self.gregorian.component(.month, from: sessionDate)
            let yearSession: Int! = self.gregorian.component(.year, from: sessionDate)
            
   
            
            
            if daySession == day && monthSession == month && yearSession == year
            {
                return 1
            }
        }
        
        return 0
    }
    
    /**
     Image for date.
     **/
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let day: Int! = self.gregorian.component(.day, from: date)
        return [13,24].contains(day) ? UIImage(named: "icon_cat") : nil
    }
    
    
    
    // MARK:- Target actions
//    @IBAction func toggleClicked(sender: AnyObject) {
//        if self.calendar.scope == .month {
//            self.calendar.setScope(.week, animated: true)
//        } else {
//            self.calendar.setScope(.month, animated: true)
//        }
//    }
    
}

extension SessionsTableViewController: UITableViewDataSource, UITableViewDelegate{
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // get different days
        sessionDates = FirebaseDatabaseHelper.getDifferentSessionDates()
//        return sessionDates.count
        
        return 1
    }
    
    // MARK: - Table view data source
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return DatesHandler.dateToStringWithoutHour(eventDate: sessionDates[section])
        return "123"
    }
    
    // MARK: UITableView Delegate methods
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchSessionsFromDay(date: self.currentDate!).count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let session = fetchSessionsFromDay(date: self.currentDate!)[indexPath.row]
        
        // get patient from session
        let patient = PatientsManagement.getPatientFromSession(session: session)
        
        cell.textLabel?.text = patient!.name
        cell.detailTextLabel?.text = ""
        
        //        toggleCellCheckbox(cell, isCompleted: patient.favorite)
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // remove from Firebase using reference
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // groceryItem is a Snapshot instance
            let groceryItem = sessions[indexPath.row]
            groceryItem.ref?.removeValue()
        }
    }
    
    // select a row
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1 - get cell
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // 2 - get grocery item
        let selectedPatient = sessions[indexPath.row]
        // 3 - toogle ckmpletion
        //        let toggledCompletion = !groceryItem.favorite
        //        // 4 - update
        //        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        //        // 5 - tell Firebase "I updated my field called completed"
        //        groceryItem.ref?.updateChildValues([
        //            "completed": toggledCompletion
        //            ])
        
        //        // Perform Segue - go to patient's profile
        //        performSegue(withIdentifier: SeguePatientViewController, sender: self)
        //        tableView.deselectRow(at: indexPath, animated: true)
    }

}

