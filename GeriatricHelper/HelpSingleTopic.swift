//
//  HelpTableViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 25/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class HelpSingleTopic: UITableViewController {

    var helpTopics:[String]? = ["Sobre a Avaliação Geriátrica Global",
                                "Funcionalidades",
                                "Área Pessoal",
                                "Pacientes",
                                "Sessões",
                                "Prescrições",
                                "Guia da AGG"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (helpTopics?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
         cell.textLabel?.text = helpTopics?[indexPath.row]
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
    
    
    
    // prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ViewAreaScales {
            // pass area to the controller
            let areaName = Constants.cgaAreas[(tableView.indexPathForSelectedRow?.row)!]
            
            
            let destinationViewController = segue.destination as! CGAPublicScalesForArea
            // set the author
            destinationViewController.area = areaName
            
            
        }
        
    }

}
