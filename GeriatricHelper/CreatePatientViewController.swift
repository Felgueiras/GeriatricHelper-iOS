//
//  CreatePatientViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 23/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import SwiftMessages

class CreatePatientViewController: UIViewController {

    
    var birthDate: Date?
    
    
    @IBOutlet weak var genderPickerView: UIPickerView!
   
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
         dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @objc func datePickerChanged() {
        var dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        var strDate = dateFormatter.string(from: datePicker.date)
        print(strDate)
        
        // grab the selected data from the date picker
        birthDate = self.datePicker.date
        
        //use NSCalenda
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))
        //        let myComponents = myCalendar?.components(.WeekdayCalendarUnit | .YearCalendarUnit, fromDate: chosenDate)
        //        let weekDay = myComponents?.weekday
        //        let year =varComponents?.year
    }
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var address: UITextField!
    
   
    @IBOutlet weak var hospitalProcessNumber: UITextField!

    var genders: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // add method to be called when changing value in date picker
        datePicker.addTarget(self, action: #selector(CreatePatientViewController.datePickerChanged), for: UIControlEvents.valueChanged)
        
        // get the number of patients
        print("There are " + String(PatientsManagement.getPatients().count) + " patients")
        
        // set up picker
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        
        genders = ["male", "female"]
    }
    
    // MARK: Create Patient
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        // Alert controller to show when there are errors
        let alert = UIAlertController(title: nil,
                                      message: "Do you wish to cancel this CGA Session?",
                                      preferredStyle: .alert)
        
        
        let cancelAction = UIAlertAction(title: "Dismiss",
                                         style: .default)
        
        alert.addAction(cancelAction)
        
        
        
        // MARK: name validation
        if name.text?.characters.count == 0{
            alert.message = "You must enter a name"
            present(alert, animated: true, completion: nil)
            return
        }
        
        // MARK: birth date validation
        if birthDate == nil{
            
            alert.message = "You must enter a birth Date"
            present(alert, animated: true, completion: nil)
            return
        }
        
        // MARK: address validation
        if address.text?.characters.count == 0{
            
            alert.message = "You must enter an address"
            present(alert, animated: true, completion: nil)
            return
        }
        
        // MARK: hospital process number validation
        if hospitalProcessNumber.text?.characters.count == 0{
            
            alert.message = "You must enter an hospital process number"
            present(alert, animated: true, completion: nil)
            return
        }
        
    
        
        /**
         radioGroup = (RadioGroup) view.findViewById(R.id.myRadioGroup);
         radioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
         @Override
         public void onCheckedChanged(RadioGroup group, int checkedId) {
         // find which radio button is selected
         if (checkedId == R.id.maleButton) {
         patientGender = "male";
         } else if (checkedId == R.id.femaleButton) {
         patientGender = "female";
         }
         }
         });
         
         // birth date
         day = (EditText) view.findViewById(R.id.birth_date_day);
         month = (EditText) view.findViewById(R.id.birth_date_month);
         year = (EditText) view.findViewById(R.id.birth_date_year);
         
         // hospital process number
         processNumber = (EditText) view.findViewById(R.id.processNumber);
         
         Button savePatient = (Button) view.findViewById(R.id.saveButton);
         savePatient.setOnClickListener(new View.OnClickListener() {
         @Override
         public void onClick(View v) {
         /**
         * Create PATIENT.
         */
         
         if (patientName.getText().length() == 0) {
         Snackbar.make(getView(), R.string.create_patient_error_name, Snackbar.LENGTH_SHORT).show();
         return;
         }
         // birth date validation
         String dayText = day.getText().toString();
         String monthText = month.getText().toString();
         String yearText = year.getText().toString();
         if (dayText.equals("") || monthText.equals("") || yearText.equals("")) {
         Snackbar.make(getView(), R.string.create_patient_error_no_birthDate, Snackbar.LENGTH_SHORT).show();
         return;
         }
         if (Integer.parseInt(dayText) > 31 || Integer.parseInt(monthText) > 12) {
         Snackbar.make(getView(), R.string.create_patient_error_invalid_birthDate, Snackbar.LENGTH_SHORT).show();
         return;
         }
         Calendar c = Calendar.getInstance();
         c.set(Integer.parseInt(yearText),
         Integer.parseInt(monthText) - 1,
         Integer.parseInt(dayText));
         Date selectedDate = c.getTime();
         
         if (patientGender == null) {
         Snackbar.make(getView(), R.string.create_patient_error_gender, Snackbar.LENGTH_SHORT).show();
         return;
         }
         if (patientAddress.getText().length() == 0) {
         Snackbar.make(getView(), R.string.create_patient_error_address, Snackbar.LENGTH_SHORT).show();
         return;
         }
         
         if (processNumber.getText().length() == 0) {
         Snackbar.make(getView(), R.string.create_patient_error_process_number, Snackbar.LENGTH_SHORT).show();
         return;
         }
         **/
        
        
        // create patient and save it
        
        var patient = Patient()
        patient.name = name.text
        
        //         patient.setBirthDate(selectedDate);
        
        
        patient.guid = "PATIENT" + String(arc4random())
        patient.address = address.text
        patient.gender = genders[genderPickerView.selectedRow(inComponent: 0)]
        
        patient.processNumber = hospitalProcessNumber.text
        patient.favorite = false
        
        PatientsManagement.createPatient(patient: patient)
        
        SwiftMessagesHelper.showMessage(type: Theme.success, text: "Pacient criado com sucesso")
        
        // go back to list of patients
        dismiss(animated: true, completion: nil)
    }
    
    
    
}


extension CreatePatientViewController: UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    
}
