//
//  QuestionCategoryViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 24/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class QuestionCategoryViewController: UIViewController {

    
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var categoryDescription: UILabel!
    @IBOutlet weak var table: UITableView!
    
    var pageIndex: Int = 0
    
    var category: String?
    var descriptionText: String?
    
    var scale:GeriatricScale?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        categoryName.text = category
        categoryDescription.text = descriptionText
        
        // set delegate for questions table
        self.table.delegate = self
        self.table.dataSource = self
    }



}

extension QuestionCategoryViewController: UITableViewDataSource, UITableViewDelegate  {
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of questions for this category
        return (scale?.questionsCategories![pageIndex].questions?.count)!
        
    }
    
    // get cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("RightWrongQuestionTableViewCell", owner: self, options: nil)?.first as! RightWrongQuestionTableViewCell
        
        let question = scale?.questionsCategories![pageIndex].questions?[indexPath.row]
        
        return RightWrongQuestionTableViewCell.createCell(cell: cell,
                                                     question: question!,
                                                     scale: scale!,
                                                     category: (scale?.questionsCategories![pageIndex])!)
        
    }
    
    
}
