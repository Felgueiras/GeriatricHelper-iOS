//
//  CGAPublicMultipleCategories.swift
//  GeriatricHelper
//
//  Created by felgueiras on 24/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

class CGAPublicMultipleCategories: UIPageViewController, UIPageViewControllerDataSource {
    
    var scale:GeriatricScale?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if scale?.questionsCategories?.count == 0{
            // add question categories to scale
            addQuestionCategoriesToScale()
        }
        
        self.dataSource = self
    
    
        // load the first page
        self.setViewControllers([getViewControllerAtIndex(0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
    }
    
    // add questions to this scale
    func addQuestionCategoriesToScale(){
        // get questions from Constants
        let questionCategories = Constants.getQuestionCategoriesForScale(scaleName: (scale?.scaleName)!)
        
        scale?.questionsCategories = questionCategories
        
    }
    
    // MARK:- UIPageViewControllerDataSource Methods
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let pageContent: QuestionCategoryViewController = viewController as! QuestionCategoryViewController
        
        var index = pageContent.pageIndex
        
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        
        index -= 1;
        return getViewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let pageContent: QuestionCategoryViewController = viewController as! QuestionCategoryViewController
        
        var index = pageContent.pageIndex
        
        if (index == NSNotFound)
        {
            return nil;
        }
        
        index += 1;
        if (index == scale?.questionsCategories?.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index)
    }
    
    // MARK:- Other Methods
    func getViewControllerAtIndex(_ index: NSInteger) -> QuestionCategoryViewController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionCategoryViewController") as! QuestionCategoryViewController
        

        
        pageContentViewController.category = scale?.questionsCategories?[index].category
        pageContentViewController.pageIndex = index
        pageContentViewController.scale = scale
        pageContentViewController.descriptionText = scale?.questionsCategories?[index].descriptionText
        
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        // TODO
        return 3
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        // TODO
        return 0
    }
}
