//
//  PopUpViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 23/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit



class TextPopUpViewController: UIViewController {
    
    @IBOutlet weak var text: UILabel?
    
    var displayText: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//         self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
//        self.view.backgroundColor = UIColor.clear
//        self.view.isOpaque = false
        
        text?.text = displayText
        
        self.showAnimate()
        
        // TODO set size
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
