//
//  ReviewPublicSessionTableViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 20/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class ReviewPublicSessionTableViewController: UIViewController {
    
    let ViewScaleQuestionsSegue = "ViewScaleQuestions"
    
    let ViewScaleYesNoSegue = "YesNoQuestion"
    
    let ViewScaleSingleQuestionChoicesSegue = "CGAViewSingleQuestionChoices"
    
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.table.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let scalesForArea = Constants.getScalesForAreaFromSession(area: Constants.cgaAreas[segmentedControl.selectedSegmentIndex],scales: Constants.cgaPublicScales!)
        
        
        if segue.identifier == ViewScaleQuestionsSegue {
            
            let scale = scalesForArea[(table.indexPathForSelectedRow?.row)!]
            let destinationViewController = segue.destination as! CGAPublicScalesQuestions
            // set the author
            destinationViewController.scale = scale
            
        }
        else if segue.identifier == ViewScaleSingleQuestionChoicesSegue {
            let scale = scalesForArea[(table.indexPathForSelectedRow?.row)!]
            let destinationViewController = segue.destination as! CGAPublicScaleSingleChoice
            // set the author
            destinationViewController.scale = scale
        }
        else if segue.identifier == ViewScaleYesNoSegue {
            let scale = scalesForArea[(table.indexPathForSelectedRow?.row)!]
            
            let destinationViewController = segue.destination as! CGAPublicYesNo
            // set the author
            destinationViewController.scale = scale
            
            
        }
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
        let cell = Bundle.main.loadNibNamed("ScaleTableViewCell", owner: self, options: nil)?.first as! ScaleTableViewCell
        
        // get scale
        let scalesForArea = Constants.getScalesForAreaFromSession(area: Constants.cgaAreas[segmentedControl.selectedSegmentIndex],scales: Constants.cgaPublicScales!)
        let scale = scalesForArea[indexPath.row]
        
        
        return ScaleTableViewCell.createCell(cell: cell, scale: scale, viewController: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // return the height of the cell
        return 100
    }
    
    
    // select a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get cell and selected scale
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        
        // get the completed scales for the current area
        let scalesForArea = Constants.getScalesForAreaFromSession(area: Constants.cgaAreas[segmentedControl.selectedSegmentIndex],scales: Constants.cgaPublicScales!)
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
