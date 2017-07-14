//
//  ReviewSessionTableViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 20/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import SwiftMessages

class ReviewSessionTableViewController: UIViewController {
    
    var session: Session?
    
    var scales: [GeriatricScale]? = []
    
    // MARK: segues identifiers
    let ViewScaleQuestionsSegue = "ViewScaleQuestions"
    let ViewScaleYesNoSegue = "YesNoQuestion"
    let ViewScaleSingleQuestionChoicesSegue = "CGAViewSingleQuestionChoices"
    
    // MARK: actions and outlets
    @IBAction func createPdfButtonClicked(_ sender: Any) {
        
    }
    
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
        var completedScales: [GeriatricScale] = []
        for scale in scales!{
            if scale.completed == true{
                completedScales.append(scale)
            }
        }
        
        self.scales = completedScales
        
        // set delegate for table
        self.table.delegate = self
        self.table.dataSource = self
        
        SwiftMessagesHelper.showMessage(type: Theme.success, text: StringHelper.sessionFinished)
        
        // deactivate segmented control areas with no scales
        for index in 0..<segmentedControl.numberOfSegments{
        
            let scalesForArea = Constants.getScalesForAreaFromSession(
                area: Constants.cgaAreas[index],
                scales: scales!)
            
            if scalesForArea.count == 0{
                segmentedControl.setEnabled(false, forSegmentAt: index)
            }
            else
            {
                // select this segment
                segmentedControl.selectedSegmentIndex = index
            
            }
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.table.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let scalesForArea = Constants.getScalesForAreaFromSession(area: Constants.cgaAreas[segmentedControl.selectedSegmentIndex],scales: scales!)
        
        
        if segue.identifier == ViewScaleQuestionsSegue {
            
            let scale = scalesForArea[(table.indexPathForSelectedRow?.row)!]

            let destinationViewController = segue.destination as! CGAPublicScalesQuestions
            destinationViewController.scale = scale
            destinationViewController.session = session
            
        }
        else if segue.identifier == ViewScaleSingleQuestionChoicesSegue {
            let scale = scalesForArea[(table.indexPathForSelectedRow?.row)!]

            let destinationViewController = segue.destination as! CGAScaleSingleChoice
            destinationViewController.scale = scale
            destinationViewController.session = session
            
        }
        else if segue.identifier == ViewScaleYesNoSegue {
            let scale = scalesForArea[(table.indexPathForSelectedRow?.row)!]

            let destinationViewController = segue.destination as! CGAPublicYesNo
            destinationViewController.scale = scale
            destinationViewController.session = session

        }
        
        
    }
    
    

}

extension ReviewSessionTableViewController: UITableViewDataSource, UITableViewDelegate  {
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentedControl.selectedSegmentIndex == -1{
        return 0
        }
        // get the completed scales for the current area
        let scalesForArea = Constants.getScalesForAreaFromSession(
            area: Constants.cgaAreas[segmentedControl.selectedSegmentIndex],
                                              scales: scales!)
        
        return scalesForArea.count
    }
    
    // get cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ScaleTableViewCell", owner: self, options: nil)?.first as! ScaleTableViewCell
        
        // get scale
        let scalesForArea = Constants.getScalesForAreaFromSession(area: Constants.cgaAreas[segmentedControl.selectedSegmentIndex],scales: scales!)
        let scale = scalesForArea[indexPath.row]
        
        
        return ScaleTableViewCell.createCell(cell: cell, scale: scale, viewController: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // return the height of the cell
        return 175
    }
    
    
    // select a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get cell and selected scale
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        
        // get the completed scales for the current area
        let scalesForArea = Constants.getScalesForAreaFromSession(area: Constants.cgaAreas[segmentedControl.selectedSegmentIndex],scales: scales!)
        let scale = scalesForArea[indexPath.row]
        
        if scale.singleQuestion!{
            // single question scale - display the choices
            performSegue(withIdentifier: ViewScaleSingleQuestionChoicesSegue, sender: self)
            
        }
        else{
            // multiple choice
            
            if scale.questions?.first?.yesOrNo == true {
                // yes/no
                // "normal" multiple choice
                performSegue(withIdentifier: ViewScaleYesNoSegue, sender: self)
            }
            else
            {
                // "normal" multiple choice
                performSegue(withIdentifier: ViewScaleQuestionsSegue, sender: self)
            }
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
