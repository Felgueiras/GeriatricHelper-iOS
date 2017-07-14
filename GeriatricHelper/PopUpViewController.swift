//
//  PopUpViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 23/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class TableItem: UITableViewCell{
    
    
    
    @IBOutlet weak var result: UILabel!
    
    @IBOutlet weak var value: UILabel!
    
}

class PopUpViewController: UIViewController {
    
    
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

extension PopUpViewController: UITableViewDataSource, UITableViewDelegate  {
    
    /**
     
     public void fillTableScaleScoring(GeriatricScaleNonDB test, TableLayout table) {
     if (test.getScoring() != null) {
     if (!test.getScoring().isDifferentMenWomen()) {
     addTableHeader(table, false);
     
     // add content
     ArrayList<GradingNonDB> gradings = test.getScoring().getValuesBoth();
     for (GradingNonDB grading : gradings) {
     TableRow row = new TableRow(context);
     TextView grade = new TextView(context);
     grade.setBackgroundResource(background);
     grade.setPadding(paddingValue, paddingValue, paddingValue, paddingValue);
     TextView score = new TextView(context);
     score.setBackgroundResource(background);
     score.setPadding(paddingValue, paddingValue, paddingValue, paddingValue);
     //TableLayout.LayoutParams tableParams = new TableLayout.LayoutParams(TableLayout.LayoutParams.WRAP_CONTENT, TableLayout.LayoutParams.WRAP_CONTENT);
     grade.setText(grading.getGrade());
     grade.setLayoutParams(new TableRow.LayoutParams(1));
     if (grading.getMin() != grading.getMax() && grading.getMax() > grading.getMin())
     score.setText(grading.getMin() + "-" + grading.getMax());
     else
     score.setText(grading.getMin() + "");
     score.setLayoutParams(new TableRow.LayoutParams(2));
     row.addView(grade);
     row.addView(score);
     table.addView(row);
     }
     } else {
     addTableHeader(table, true);
     
     // show values for men and women
     ArrayList<GradingNonDB> gradings = test.getScoring().getValuesBoth();
     for (int i = 0; i < test.getScoring().getValuesMen().size(); i++) {
     GradingNonDB gradingMen = test.getScoring().getValuesMen().get(i);
     GradingNonDB gradingWomen = test.getScoring().getValuesWomen().get(i);
     TableRow row = new TableRow(context);
     TextView grade = new TextView(context);
     grade.setBackgroundResource(background);
     grade.setPadding(paddingValue, paddingValue, paddingValue, paddingValue);
     TextView scoreMen = new TextView(context);
     scoreMen.setBackgroundResource(background);
     scoreMen.setPadding(paddingValue, paddingValue, paddingValue, paddingValue);
     TextView scoreWomen = new TextView(context);
     scoreWomen.setBackgroundResource(background);
     scoreWomen.setPadding(paddingValue, paddingValue, paddingValue, paddingValue);
     //TableLayout.LayoutParams tableParams = new TableLayout.LayoutParams(TableLayout.LayoutParams.WRAP_CONTENT, TableLayout.LayoutParams.WRAP_CONTENT);
     grade.setText(gradingMen.getGrade());
     grade.setLayoutParams(new TableRow.LayoutParams(1));
     // men
     if (gradingMen.getMin() != gradingMen.getMax() && gradingMen.getMax() > gradingMen.getMin())
     scoreMen.setText(gradingMen.getMin() + "-" + gradingMen.getMax());
     else
     scoreMen.setText(gradingMen.getMin() + "");
     scoreMen.setLayoutParams(new TableRow.LayoutParams(2));
     // women
     if (gradingWomen.getMin() != gradingWomen.getMax() && gradingWomen.getMax() > gradingWomen.getMin())
     scoreWomen.setText(gradingWomen.getMin() + "-" + gradingWomen.getMax());
     else
     scoreWomen.setText(gradingWomen.getMin() + "");
     scoreWomen.setLayoutParams(new TableRow.LayoutParams(3));
     row.addView(grade);
     row.addView(scoreMen);
     row.addView(scoreWomen);
     table.addView(row);
     }
     }
     }
     }
     
     /**
     * Add a header to the table.
     *
     * @param table
     * @param differentMenWomen
     */
     public void addTableHeader(TableLayout table, boolean differentMenWomen) {
     
     if (!differentMenWomen) {
     // add header
     TableRow header = new TableRow(context);
     TextView result = new TextView(context);
     result.setBackgroundResource(background);
     result.setPadding(paddingValue, paddingValue, paddingValue, paddingValue);
     TextView points = new TextView(context);
     points.setBackgroundResource(background);
     points.setPadding(paddingValue, paddingValue, paddingValue, paddingValue);
     result.setText("Resultado");
     points.setText("Pontuação");
     result.setLayoutParams(new TableRow.LayoutParams(1));
     points.setLayoutParams(new TableRow.LayoutParams(2));
     header.addView(result);
     header.addView(points);
     table.addView(header);
     } else {
     TableRow header = new TableRow(context);
     TextView result = new TextView(context);
     result.setBackgroundResource(background);
     result.setPadding(paddingValue, paddingValue, paddingValue, paddingValue);
     TextView men = new TextView(context);
     men.setBackgroundResource(background);
     men.setPadding(paddingValue, paddingValue, paddingValue, paddingValue);
     TextView women = new TextView(context);
     women.setBackgroundResource(background);
     women.setPadding(paddingValue, paddingValue, paddingValue, paddingValue);
     result.setText("Resultado");
     men.setText("Homem");
     women.setText("Mulher");
     result.setLayoutParams(new TableRow.LayoutParams(1));
     men.setLayoutParams(new TableRow.LayoutParams(2));
     women.setLayoutParams(new TableRow.LayoutParams(3));
     header.addView(result);
     header.addView(men);
     header.addView(women);
     table.addView(header);
     }
     
     }
     }
     
     
     
     **/
    

    
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var itemCount = 0
        
        // TODO different men women
        return (scaleNonDB?.scoring?.valuesBoth?.count)!
    }
    
    // get cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.scoringTable.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! TableItem
        
        if scaleNonDB?.scoring?.differentMenWomen == false{
            // same score for both genders
            
            
            // add content
            var gradings = scaleNonDB?.scoring?.valuesBoth
            
            let currentGrading = gradings![indexPath.row]
            cell.result.text = currentGrading.grade!
            
            if (currentGrading.min)! != (currentGrading.max!) && (currentGrading.max)! > (currentGrading.min!){
                
                cell.value.text = String(describing: currentGrading.min!) + "-" + String(describing: currentGrading.max!)
            }
            else
            {
                cell.value.text = String(describing: currentGrading.min!)
            }
            
        }
        
        return cell
    }
    
    
}
