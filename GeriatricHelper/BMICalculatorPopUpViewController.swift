//
//  PopUpViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 23/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import Foundation



class BMICalculatorPopUpViewController: UIViewController {
    

    @IBOutlet weak var height: UITextField!
    
    @IBOutlet weak var weight: UITextField!

    @IBOutlet weak var bmiResult: UILabel!
    
    @IBAction func calculateBMIButtonClicked(_ sender: Any) {
        
        // validation
        if height.text! == ""
        {
            return
        }
        if weight.text! == ""
        {
            return 
        }
        
        
        // read height and weight
        let heightVal = Double(height.text!)! * 0.01
        let weightVal = Double(weight.text!)
        
        let bmi = round(weightVal! / (heightVal*heightVal))
        
        // calculate BMI
        bmiResult.text = String(bmi)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        
        self.showAnimate()
        
        bmiResult.text = ""
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
