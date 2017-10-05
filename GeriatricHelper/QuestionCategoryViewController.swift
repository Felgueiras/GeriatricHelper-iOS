//
//  QuestionCategoryViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 24/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import FirebaseStorage

class QuestionCategoryViewController: UIViewController {
    
    
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var categoryDescription: UILabel!
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var categoryInstructions: UILabel!
    @IBOutlet weak var categoryIndex: UILabel!
    
    @IBOutlet weak var arrowRight: UIButton!
    @IBOutlet weak var arrowLeft: UIButton!
    var pageIndex: Int = 0
    
    var category: String?
    var descriptionText: String?
    
    var scale:GeriatricScale?
    
    var pageViewController: UIPageViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        categoryName.text = category
        categoryDescription.text = descriptionText
        categoryIndex.text = String(pageIndex+1) + "/" + String(describing: scale!.questionsCategories!.count)
        
        categoryInstructions.text = scale!.questionsCategories![pageIndex].notes
        
        // set delegate for questions table
        self.table.delegate = self
        self.table.dataSource = self
        
        if pageIndex == 0
        {
            // disable left arrow
            arrowLeft.isHidden = true
        }
        
        if pageIndex == (scale?.questionsCategories?.count)!-1
        {
            // disable right arrow
            arrowRight.isHidden = true
        }
        
    }
    
    // handle arrow clicks
    @IBAction func arrowClicked(_ sender: UIButton) {
        // programatically switch between pages
        let parent = self.parent as! UIPageViewController
        
        switch sender{
        case arrowLeft:
            // left
            print("left")
            parent.goToPreviousPage(animated: true)
        case arrowRight:
            // right
            print("right")
            parent.goToNextPage(animated: true)
        default:
            // do sth
            print("???")
        }
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
        
        if question!.image != ""
        {
            // add gesture recognizer to the cell's image
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(QuestionCategoryViewController.imageTapped(_:)))
            
            
            cell.questionImage.addGestureRecognizer(tapRecognizer)
        }
        
        
        
        return RightWrongQuestionTableViewCell.createCell(cell: cell,
                                                          cellIndex: indexPath.row,
                                                          scale: scale!,
                                                          category: (scale?.questionsCategories![pageIndex])!,
                                                          categoryLabel: categoryName,
                                                          table:self.table)
        
    }
    
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        // sender is button inside cell
        
        // access cell question
        let cell = sender.view?.superview?.superview as! RightWrongQuestionTableViewCell
        
        // load image from Firebase
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://appprototype-bdd27.appspot.com")
        let criteriaRef = storageRef.child("images")
        
        
        
        // create reference to file
        let criteria = criteriaRef.child(cell.questionObj!.image!)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        criteria.data(withMaxSize: 4 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                let firebaseImage: UIImage! = UIImage(data: data!)
                
                let newImageView = UIImageView(image: firebaseImage)
                newImageView.frame = UIScreen.main.bounds
                newImageView.backgroundColor = .white
                newImageView.contentMode = .scaleAspectFit
                newImageView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
                newImageView.addGestureRecognizer(tap)
                self.view.addSubview(newImageView)
                self.navigationController?.isNavigationBarHidden = false
                self.tabBarController?.tabBar.isHidden = false
                
                
            }
        }
        
        
        
        
        
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // TODO return the height of the cell
        return 100
    }
    
    
    
}
