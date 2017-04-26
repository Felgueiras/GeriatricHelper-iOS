//
//  HelpTableViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 25/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class HelpTableViewController: UITableViewController {

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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
