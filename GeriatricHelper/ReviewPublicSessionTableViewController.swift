//
//  ReviewPublicSessionTableViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 20/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class ReviewPublicSessionTableViewController: UIViewController {
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentedControlSelectionChanged(_ sender: Any) {
        // reload the data
        self.table.reloadData()
    }
    
    
    @IBOutlet weak var table: UITableView!
    
    
    @IBAction func finishReviewButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "FinishReviewingPublicSession", sender: self)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // get the scales that were completed
        for scale in Constants.cgaPublicScales!{
            if scale.completed == true{
                print("Completed scale " + scale.scaleName!)
                print(scale.answer)
            }
        }
        
        // set delegate for table
        self.table.delegate = self
        self.table.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ReviewPublicSessionTableViewController: UITableViewDataSource, UITableViewDelegate  {
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // get the completed scales for the current area
        let scalesForArea = Constants.getScalesForAreaFromSession(
            area: Constants.cgaAreas[segmentedControl.selectedSegmentIndex],
                                              scales: Constants.cgaPublicScales!)
        
        return scalesForArea.count
    }
    
    // get cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        // get the completed scales for the current area
        let scalesForArea = Constants.getScalesForAreaFromSession(area: Constants.cgaAreas[segmentedControl.selectedSegmentIndex],
                                                                  scales: Constants.cgaPublicScales!)
        
        
        
        // prescriptions
        let scale = scalesForArea[indexPath.row]
        
        cell.textLabel?.text = scale.scaleName
        cell.detailTextLabel?.text = String(describing: scale.completed)
        
        
        
        return cell
    }
    
    
    
    
    
    
    
}
