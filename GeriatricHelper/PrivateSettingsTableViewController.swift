//
//  PrivateSettingsTableViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 22/05/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import ObjectMapper


class PrivateSettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // detect log out
        if indexPath.section == 2 && indexPath.row == 0{
            self.signOut()
        }
        
    }


    // sign out
    func signOut() {
        
        let alert = UIAlertController(title: "Logout",
                                      message: "Deseja mesmo fazer log out",
                                      preferredStyle: .alert)
        
        
        // cancel the current session
        let saveAction = UIAlertAction(title: "Sim",
                                       style: .default) { _ in
                                        
                                        // prompt if really wants to log out
                                        
                                        do {
                                            try        FIRAuth.auth()!.signOut()
                                            self.performSegue(withIdentifier: "LogOutSegue", sender: self)
                                            print("Sining out")
                                        } catch {
                                            print("Error: \(error)")
                                        }
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Não",
                                         style: .default)
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }


}
