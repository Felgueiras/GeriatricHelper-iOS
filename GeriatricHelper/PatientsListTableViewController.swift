/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PatientsListTableViewController: UITableViewController {
    
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
        
        
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        userCountBarButtonItem = UIBarButtonItem(title: "1",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(userCountButtonDidTouch))
        userCountBarButtonItem.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = userCountBarButtonItem
        
        user = User(uid: "FakeId", email: "hungry@person.food")
        
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
            
            // get all patients
            self.ref.child("users").child(userID!).child("patients").observe(.value, with: {snapshot in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let username = value?["name"] as? String ?? ""
                // let user = User.init(username: username)

                
                // 3
                for item in snapshot.children {
                    // 4
                    let patient = Patient(snapshot: item as! FIRDataSnapshot)
//                    print(patient)
                    self.patients.append(patient)
                }
                self.tableView.reloadData()
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            
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
    
    // MARK: UITableView Delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let patient = patients[indexPath.row]
        
        cell.textLabel?.text = patient.name
        cell.detailTextLabel?.text = patient.name
        
        toggleCellCheckbox(cell, isCompleted: patient.favorite)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // remove from Firebase using reference
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // groceryItem is a Snapshot instance
            let groceryItem = patients[indexPath.row]
            groceryItem.ref?.removeValue()
        }
    }
    
    // FIREBASE IMPLEMENTATION
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1 - get cell
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // 2 - get grocery item
        let groceryItem = patients[indexPath.row]
        // 3 - toogle ckmpletion
        let toggledCompletion = !groceryItem.favorite
        // 4 - update
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        // 5 - tell Firebase "I updated my field called completed"
        groceryItem.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
    }
    
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
