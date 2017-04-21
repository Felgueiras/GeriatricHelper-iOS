import UIKit
import FirebaseAuth
import FirebaseDatabase

class FavoritePatientsCollectionViewController: UICollectionViewController {
    
    fileprivate let itemsPerRow: CGFloat = 3
    
    fileprivate let reuseIdentifier = "ItemCell"
    
    // MARK: Constants
    let listToUsers = "ListToUsers"
    
    // MARK: Properties
    var patients: [Patient] = []
    var user: User!
    var userCountBarButtonItem: UIBarButtonItem!
    // Firebase reference to database
    let ref = FIRDatabase.database().reference()
    
    // check the users who area online - "online" users table
    //    let usersRef = FIRDatabase.database().reference(withPath: "online")
    
    
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        tableView.allowsMultipleSelectionDuringEditing = false
//        
//        userCountBarButtonItem = UIBarButtonItem(title: "1",
//                                                 style: .plain,
//                                                 target: self,
//                                                 action: #selector(userCountButtonDidTouch))
//        userCountBarButtonItem.tintColor = UIColor.white
//        navigationItem.leftBarButtonItem = userCountBarButtonItem
//        
//        user = User(uid: "FakeId", email: "hungry@person.food")
        
        // observe - value event type = listen for every change in data in the DB
        // 1 - order by completion
        //        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
        //            var newItems: [GroceryItem] = []
        //
        //            for item in snapshot.children {
        //                let groceryItem = GroceryItem(snapshot: item as! FIRDataSnapshot)
        //                newItems.append(groceryItem)
        //            }
        //
        //            self.patients = newItems
        //            self.tableView.reloadData()
        //        })
        
        // add a state change listener - save the user
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            // reference the user
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            // reference the patients
            let patientsRef = self.ref.child("users").child(userID!).child("patients")
            // make query - retrieve favorite patients
            
            patientsRef.queryOrdered(byChild: "favorite").queryEqual(toValue: true) .observe(.value, with: { snapshot in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let username = value?["name"] as? String ?? ""
                // let user = User.init(username: username)
                self.patients.removeAll()
                
                // 3
                for item in snapshot.children {
                    // 4
                    let patient = Patient(snapshot: item as! FIRDataSnapshot)
                    //                    print(patient)
                    self.patients.append(patient)
                }
                
                self.collectionView?.reloadData()
//                self.tableView.reloadData()
                
            })
        
            
            
            
            //            // 1 - get ref to current user
            //            let currentUserRef = self.usersRef.child(self.user.uid)
            //            // 2 - save the current user's email into ref
            //            currentUserRef.setValue(self.user.email)
            //            // 3  This removes the value at the reference’s location after the connection to Firebase closes, for instance when a user quits
            //            // your app
            //            currentUserRef.onDisconnectRemoveValue()
        }
        
        // get the number of users online
        //        usersRef.observe(.value, with: { snapshot in
        //            if snapshot.exists() {
        //                self.userCountBarButtonItem?.title = snapshot.childrenCount.description
        //            } else {
        //                self.userCountBarButtonItem?.title = "0"
        //            }
        //        })
    }

    
    //1
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return self.patients.count
    }
    
    //3
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! FavoritePatientCellCollectionViewCell
        //2
        let patient = self.patients[indexPath.row]
        cell.backgroundColor = UIColor.white
        //3
//        cell.patientName.text = patient.name
        
        cell.patient = patient
        
        return cell
    }

    

    
    // FIREBASE IMPLEMENTATION
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // 1 - get cell
//        guard let cell = tableView.cellForRow(at: indexPath) else { return }
//        // 2 - get grocery item
//        let groceryItem = patients[indexPath.row]
//        // 3 - toogle ckmpletion
//        let toggledCompletion = !groceryItem.favorite
//        // 4 - update
//        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
//        // 5 - tell Firebase "I updated my field called completed"
//        groceryItem.ref?.updateChildValues([
//            "completed": toggledCompletion
//            ])
//    }
    
    // changeUI depending on item being completed or not
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }
    }
    
    // MARK: Add Item
    
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Grocery Item",
                                      message: "Add an Item",
                                      preferredStyle: .alert)
        
        
        // save an item to Firebase
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
                                        // 1 - get text
                                        guard let textField = alert.textFields?.first,
                                            let text = textField.text else { return }
                                        
                                        // 2 - create grocery item
                                        let groceryItem = GroceryItem(name: text,
                                                                      addedByUser: self.user.email,
                                                                      completed: false)
                                        // 3 - create reference to new child - key value is text in lowercase
                                        let groceryItemRef = self.ref.child(text.lowercased())
                                        
                                        // 4 - set value (save to firebase) - expects a dictionary,
                                        // GroceryItem has a method that turns it into a Dictionary
                                        groceryItemRef.setValue(groceryItem.toAnyObject())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func userCountButtonDidTouch() {
        performSegue(withIdentifier: listToUsers, sender: nil)
    }
    
}

fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)


extension FavoritePatientsCollectionViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
