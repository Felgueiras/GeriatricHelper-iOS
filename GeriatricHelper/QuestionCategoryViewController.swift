//
//  QuestionCategoryViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 24/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import FirebaseStorage
import SwiftMessages

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
    
    @IBOutlet weak var saveButton: UIButton!
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
        
        // disable item selection
        table.allowsSelection = false
        
    }
    func checkScaleCompleted()
    {
        var questionsToAnswer = 0
        
        // check all questions for every QuestionCategory
        var allQuestionsAnswered = true
        
        for questionCat in (scale?.questionsCategories)!{
            for question in questionCat.questions!{
                if question.answered != true{
                    allQuestionsAnswered = false
                    questionsToAnswer += 1
                }
            }
        }
        
        if allQuestionsAnswered == true{
          
            let saveButtonTitle = SwiftMessagesHelper.saveScale
            saveButton.setTitle(saveButtonTitle, for: .normal)
        }
        else
        {
            let saveButtonTitle = SwiftMessagesHelper.saveScale + " (faltam " + String(questionsToAnswer) + " questões)"
            saveButton.setTitle(saveButtonTitle, for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // display number of questions to answer
        checkScaleCompleted()
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
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        // check if scale was completed
        if scale?.completed == false || scale?.completed == nil {
            // show alert
            let alert = UIAlertController(title: SwiftMessagesHelper.saveScale,
                                          message: "Escala incompleta, continuar a preencher a escala?",
                                          preferredStyle: .alert)
            
            
            // cancel the current session
            let saveAction = UIAlertAction(title: "Sair da escala",
                                           style: .destructive) { _ in
                                            
                                            
                                            
                                            _ = self.navigationController?.popViewController(animated: true)
                                            //                                            self.performSegue(withIdentifier: "CGAPublicCancelSegue", sender: self)
                                            
            }
            
            let cancelAction = UIAlertAction(title: "Continuar",
                                             style: .default)
            
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
            
            
        }
        else{
            
            _ = self.navigationController?.popViewController(animated: true)
            SwiftMessagesHelper.showMessage(type: Theme.info,
                                            text: StringHelper.scaleSaved)
            
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
                                                          viewController:self)
        
    }
    
    func questionAnswered(){
        
    }
    
    
    func imageTapped(_ sender: UITapGestureRecognizer) {
        // load from internal memory
        
        // access cell question
        let cell = sender.view?.superview?.superview as! RightWrongQuestionTableViewCell
        
        let imageName = cell.questionObj!.image!
        
        let fileManager = FileManager.default
        let imagePAth = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePAth){
            let firebaseImage = UIImage(contentsOfFile: imagePAth)
            
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
  
        }else{
            print("No Image")
        }

    }
    
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // TODO return the height of the cell
        return 100
    }
    
    
    
}
