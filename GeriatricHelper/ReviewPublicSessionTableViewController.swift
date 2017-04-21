//
//  ReviewPublicSessionTableViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 20/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class ReviewPublicSessionTableViewController: UITableViewController {
    
    
    func generateTestResult()
    {
        /**
         public double generateTestResult() {
         double res = 0;
         ArrayList<Question> questionsFromTest = getQuestionsFromScale();
         
         if (singleQuestion) {
         //system.out.println("SINGLE");
         ScoringNonDB scoring = Scales.getScaleByName(this.getScaleName()).getScoring();
         ArrayList<GradingNonDB> valuesBoth = scoring.getValuesBoth();
         for (GradingNonDB grade : valuesBoth) {
         if (grade.getGrade().equals(answer)) {
         this.result = Double.parseDouble(grade.getScore());
         this.save();
         return Double.parseDouble(grade.getScore());
         }
         }
         } else {
         for (Question question : questionsFromTest) {
         // in the Hamilton scale, only the first 17 questions make up the result
         if (testName.equals(Constants.test_name_hamilton) &&
         questionsFromTest.indexOf(question) > 16)
         break;
         /**
         * Yes/no Question
         */
         if (question.isYesOrNo()) {
         String selectedYesNoChoice = question.getSelectedYesNoChoice();
         if (selectedYesNoChoice.equals("yes")) {
         res += question.getYesValue();
         } else {
         res += question.getNoValue();
         }
         }
         /**
         * Right/ wrong question
         */
         else if (question.isRightWrong()) {
         if (question.getSelectedRightWrong().equals("right"))
         res += 1;
         }
         /**
         * Numerical question.
         */
         else if (question.isNumerical()) {
         System.out.println("Numerical");
         res += question.getAnswerNumber();
         }
         /**
         * Multiple Choice Question
         */
         else {
         // get the selected Choice
         String selectedChoice = question.getSelectedChoice();
         //system.out.println("Selected choice " + selectedChoice);
         ArrayList<Choice> choices = question.getChoicesForQuestion();
         //system.out.println("size " + choices.size());
         for (Choice c : choices) {
         if (c.getName().equals(selectedChoice)) {
         //system.out.println(c.toString());
         res += c.getScore();
         }
         }
         
         }
         }
         }
         
         if (testName.equals(Constants.test_name_mini_nutritional_assessment_global)) {
         // check if triagem is already answered
         Log.d("Nutritional", "Global pressed");
         
         ArrayList<GeriatricScale> allScales = GeriatricScale.getAllScales();
         
         GeriatricScale triagem = session.getScaleByName(Constants.test_name_mini_nutritional_assessment_triagem);
         res += triagem.generateTestResult();
         }
         if (testName.equals(Constants.test_name_set_set)) {
         // result is the value from the last question (scoring)
         res = questionsFromTest.get(questionsFromTest.size() - 1).getAnswerNumber();
         }
         this.result = res;
         this.save();
         
         return res;
         }

 **/
    }
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
