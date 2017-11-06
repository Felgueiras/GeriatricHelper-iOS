//
//  AddItemViewController.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 14/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
import SearchTextField

class AddPrescriptionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var prescriptionName: SearchTextField!
    
    @IBOutlet weak var prescriptionNotes: UITextField!
    
    var currentTextfield: UITextField!
    
    // MARK: Save prescription
    var saveCompletionHandler: ((_ itemDescription: String, _ price: String) -> Void)!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO add autocomplete
        
        // Set self as the delegate of the textfields.
        prescriptionName.delegate = self
        prescriptionNotes.delegate = self
        
        // Set the array of strings you want to suggest
        prescriptionName.filterStrings(["Red", "Blue", "Yellow"])
        
        // Add a tap gesture recognizer to the view to dismiss the keyboard.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddPrescriptionViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    var patient: Patient?

    
    // MARK: Custom Methods
    @objc func dismissKeyboard() {
        if currentTextfield != nil {
            currentTextfield.resignFirstResponder()
            currentTextfield = nil
        }
    }
    
    
    func presentAddItemViewControllerInViewController(originatingViewController: UIViewController, saveItemCompletionHandler: @escaping (_ itemDescription: String, _ price: String) -> Void) {
        saveCompletionHandler = saveItemCompletionHandler
        originatingViewController.navigationController?.pushViewController(self, animated: true)
    }
    
    
    // MARK: IBAction Methods
    @IBAction func saveItem(_ sender: AnyObject) {
        
        // TODO feedback
        
        if (prescriptionName.text?.characters.count)! > 0 &&
            (prescriptionNotes.text?.characters.count)! > 0 {
            
            let date = Date()
            
            // save
            var prescription = Prescription(drug: prescriptionName.text!,
                                            notes: prescriptionNotes.text!,
                                            date: date)
            
            prescription.guid = "PRESCRIPTION-" + String(arc4random())
            prescription.patientID = patient?.guid
            patient?.addPrescription(prescriptionID: prescription.guid!)
            
   
            
            // update patient
            PatientsManagement.updatePatient(patient: patient!)
            
            // save Prescription
            FirebaseDatabaseHelper.createPrescription(prescription: prescription)
            
            
            // Pop the view controller.
            _ = navigationController?.popViewController(animated: true)
            
        }
    }
    
    
    
    // MARK: UITextFieldDelegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextfield = textField
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == prescriptionName {
            textField.resignFirstResponder()
            prescriptionNotes.becomeFirstResponder()
        }
        
        return true
    }
    
}
