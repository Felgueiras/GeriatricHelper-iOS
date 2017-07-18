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


class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var showInstructionsSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide modules
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // initial switch state (from Defaults)
        if UserDefaults.standard.bool(forKey: "instructions") {
            showInstructionsSwitch.isOn = true
        } else {
            showInstructionsSwitch.isOn = false
        }
    }
    
    
    @IBAction func showInstructionsSwitchValueChanged(_ sender: Any) {
        if showInstructionsSwitch.isOn{
        // enable instructions
            UserDefaults.standard.set(true, forKey: "instructions")
        }
        else{
            // disable
            UserDefaults.standard.set(false, forKey: "instructions")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // detect log out
        if indexPath.section == 2 && indexPath.row == 0{
            
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // hide modules section
        return 2
    }
    
        
        
        
}
