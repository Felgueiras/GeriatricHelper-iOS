//
//  PopUpViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 23/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class ScoreCellEqual: UITableViewCell{
    
    
    
    @IBOutlet weak var result: UILabel!
    
    @IBOutlet weak var value: UILabel!
    
}

class ScoreCellDifferent: UITableViewCell{
    
    
    
    @IBOutlet weak var result: UILabel!
    
    @IBOutlet weak var valueMale: UILabel!
    
    @IBOutlet weak var valueFemale: UILabel!
    
}

class ScaleInfoViewController: UIViewController {
    
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var text: UILabel?
    
    @IBOutlet weak var scoringTable: UITableView!
    
    @IBOutlet weak var scaleDescription: UILabel!
    
    var scaleNonDB:GeriatricScale?
    
    var displayText: String?
    
    var scale: GeriatricScale?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        text?.text = displayText
        
        // show scale info
        name.text = scale?.scaleName
        scaleDescription.text = scale?.descriptionText
        self.scoringTable.delegate = self
        self.scoringTable.dataSource = self
        
        scaleNonDB = Constants.getScaleByName(scaleName: (scale?.scaleName)!)
        
        
        // add borders to table
        scoringTable.layer.masksToBounds = true
        scoringTable.layer.borderColor = UIColor( red: 153/255, green: 153/255, blue:0/255, alpha: 1.0 ).cgColor
        scoringTable.layer.borderWidth = 2.0
        
        
        
        self.showAnimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func closePopUp(_ sender: Any) {
        //        self.view.removeFromSuperview()
        self.removeAnimate()
        
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
}

extension ScaleInfoViewController: UITableViewDataSource, UITableViewDelegate  {
    
    
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var itemCount = 0
        
        if !(scaleNonDB?.scoring?.differentMenWomen)! {
            return (scaleNonDB?.scoring?.valuesBoth?.count)!
        }
        else{
            // different men women - check gender
            if Constants.patientGender == Constants.PatientGender.male{
                // male
                return (scaleNonDB?.scoring?.valuesMen?.count)! + 1
            }
            else
            {
                // female
                return (scaleNonDB?.scoring?.valuesWomen?.count)! + 1
            }
        }
    }
    
    // get cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        var gradings:[Grading]
        if scaleNonDB?.scoring?.differentMenWomen == false{
            let cell = self.scoringTable.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ScoreCellEqual
            // same score for both genders
            gradings = (scaleNonDB?.scoring?.valuesBoth)!
            
            let currentGrading = gradings[indexPath.row]
            cell.result.text = currentGrading.grade!
            
            if (currentGrading.min)! != (currentGrading.max!) && (currentGrading.max)! > (currentGrading.min!){
                cell.value.text = String(describing: currentGrading.min!) + "-" + String(describing: currentGrading.max!)
            }
            else
            {
                cell.value.text = String(describing: currentGrading.min!)
            }
            return cell
        }
        else
        {
            // create cell
            let cell = self.scoringTable.dequeueReusableCell(withIdentifier: "ItemCellMaleFemale", for: indexPath) as! ScoreCellDifferent
            
            // first row -> header
            if indexPath.row == 0{
                cell.result.text = "Resultado"
                cell.valueMale.text = "Homem"
                cell.valueFemale.text = "Mulher"
                return cell
            }
            
            let index = indexPath.row - 1
            
 
            
            let gradingsMale = (scaleNonDB?.scoring?.valuesMen)!
            let gradingsFemale = (scaleNonDB?.scoring?.valuesWomen)!
            
            // current grading
            var currentGrading = gradingsMale[index]
            // set result
            cell.result.text = currentGrading.grade!
            // male
            if (currentGrading.min)! != (currentGrading.max!) && (currentGrading.max)! > (currentGrading.min!){
                cell.valueMale.text = String(describing: currentGrading.min!) + "-" + String(describing: currentGrading.max!)
            }
            else
            {
                cell.valueMale.text = String(describing: currentGrading.min!)
            }
            
            // female
            // current grading
            currentGrading = gradingsFemale[index]
            if (currentGrading.min)! != (currentGrading.max!) && (currentGrading.max)! > (currentGrading.min!){
                cell.valueFemale.text = String(describing: currentGrading.min!) + "-" + String(describing: currentGrading.max!)
            }
            else
            {
                cell.valueFemale.text = String(describing: currentGrading.min!)
            }
            
            return cell
        }
        
        
    }
    
    
}
