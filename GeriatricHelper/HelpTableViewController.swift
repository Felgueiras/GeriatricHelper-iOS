//
//  HelpMain.swift
//  GeriatricHelper
//
//  Created by felgueiras on 25/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import SwiftMessages

class HelpMain: UITableViewController {
    
    let viewHelpTopic: String = "ViewHelpTopic"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SwiftMessagesHelper.showWarningMessage()
        
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HelpTopics.helpTopics.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
         cell.textLabel?.text = HelpTopics.helpTopics[indexPath.row]
        return cell
    }
    


    
    // select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get cell and selected scale
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        //        var selectedAreaIndex = segmentedControl.selectedSegmentIndex
        
        // filter scales by selected
        //        let scale = Constants.getScalesForArea(area: Constants.cgaAreas[indexPath.section])[indexPath.row]
        
        
        performSegue(withIdentifier: viewHelpTopic, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == viewHelpTopic {
            
            // pass help topic to the controller
            let selectedTopic = HelpTopics.helpTopics[(tableView.indexPathForSelectedRow?.row)!]
            
            
            let destinationViewController = segue.destination as! HelpSingleTopic
            // set the author
            destinationViewController.helpTopic = selectedTopic
            
            
        }
        
    }

}
