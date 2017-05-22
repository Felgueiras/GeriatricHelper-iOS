//
//  ReviewSessionTableViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 20/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import SwiftMessages

class ProgressTableViewController: UIViewController {
    
    var sessions: [Session]?
    var area: String?
    
    var scalesForArea: [GeriatricScale]? = []
    
    // MARK: segues identifiers

    
    // MARK: actions and outlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentedControlSelectionChanged(_ sender: Any) {
        
        self.area = Constants.cgaAreas[segmentedControl.selectedSegmentIndex]
        
        // get scales for this area
        self.scalesForArea = Constants.getScalesForArea(area: area!)
        
        // reload the data
        self.table.reloadData()
    }
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // set delegate for table
        self.table.delegate = self
        self.table.dataSource = self
        
        self.area = Constants.cgaAreas[segmentedControl.selectedSegmentIndex]
        
        // get scales for this area
        self.scalesForArea = Constants.getScalesForArea(area: area!)
        
        // reload the data
        self.table.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
//        let scalesForArea = Constants.getScalesForAreaFromSession(area: Constants.cgaAreas[segmentedControl.selectedSegmentIndex],scales: scales!)
        
        
//        if segue.identifier == ViewScaleQuestionsSegue {
//            
//            let scale = scalesForArea[(table.indexPathForSelectedRow?.row)!]
//            let destinationViewController = segue.destination as! CGAPublicScalesQuestions
//            // set the author
//            destinationViewController.scale = scale
//            
//        }
    }

}

extension ProgressTableViewController: UITableViewDataSource, UITableViewDelegate  {
    
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return scalesForArea!.count
    }
    
    // get cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ProgressChartTableViewCell", owner: self, options: nil)?.first as! ProgressChartTableViewCell

        let scale = scalesForArea![indexPath.row]
        

        return ProgressChartTableViewCell.createCell(cell: cell,
                                             scale: scale,
                                             viewController: self,
                                             rowIndex: indexPath.row,
                                             sessions:sessions!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // return the height of the cell
        return 250
    }
    
    
    
}
