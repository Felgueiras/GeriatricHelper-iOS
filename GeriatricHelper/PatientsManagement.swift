//
//  PatientsManagement.swift
//  GeriatricHelper
//
//  Created by felgueiras on 23/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import Foundation

class PatientsManagement{
    
    
    //
    //        //    static ArrayList<PatientFirebase> patients = new ArrayList<>();
    //
    /**
     * Save a Patient on the user defaults.
     *
     * @param patient
     * @param context
     */
    static func createPatient(patient: Patient) {
        
        var currentPatients = getPatients()
        currentPatients.append(patient)
        
        // write to UserDefaults
        let defaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: currentPatients)
        defaults.set(encodedData, forKey: "patients")
        defaults.synchronize()
        
    }
    
    
    //
    //
    //        /**
    //         * Get patient associated with a prescription.
    //         *
    //         * @param prescription
    //         * @param context
    //         * @return
    //         */
    //        public static PatientFirebase getPatientFromPrescription(PrescriptionFirebase prescription, Context context) {
    //        ArrayList<PatientFirebase> patients = getPatients(context);
    //        for (PatientFirebase patient : patients) {
    //        if (patient.getGuid().equals(prescription.getPatientID())) {
    //        return patient;
    //        }
    //        }
    //        return null;
    //
    //        }
    //
    
    // Get all patients from UserDefaults
    static func getPatients() -> [Patient] {
        // read from defaults
        let defaults = UserDefaults.standard
        let decoded  = defaults.object(forKey: "patients") as? Data
        if decoded == nil{
            return  []
        }
        let decodedPatients = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Patient]
        return decodedPatients
    }
 
    // Update patient
    static func updatePatient(patient: Patient) {
        var patients = getPatients()
        for i in 0..<patients.count {
            if patients[i].guid == patient.guid {
                patients[i] = patient
                // persist in user defaults
                
                let defaults = UserDefaults.standard
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: patients)
                defaults.set(encodedData, forKey: "patients")
                defaults.synchronize()
                
                return
            }
        }
    }
    
    
    static func deletePatient(patient: Patient) {
        // TODO delete sessions from this patient
//        ArrayList<SessionFirebase> sessions = FirebaseDatabaseHelper.getSessionsFromPatient(patient);
//        for (SessionFirebase session : sessions) {
//            FirebaseDatabaseHelper.deleteSession(session, context);
//        }
        
        // TODO delete prescriptions from this patient
//        ArrayList<PrescriptionFirebase> prescriptions = FirebaseDatabaseHelper.getPrescriptionsFromPatient(patient);
//        for (PrescriptionFirebase prescription : prescriptions) {
//            FirebaseDatabaseHelper.deletePrescription(prescription, context);
//        }
        
        var patients = getPatients()
        for i in 0..<patients.count {
            if patients[i].guid == patient.guid {
                patients.remove(at: i)
                // persist in user defaults
                
                print("Erasing patinet")
                
                let defaults = UserDefaults.standard
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: patients)
                defaults.set(encodedData, forKey: "patients")
                defaults.synchronize()
                
                return
            }
        }
    }
    

    /**
     Get Patient from Session.
 **/
    static  func getPatientFromSession(session: Session) -> Patient?{
        
        
        let patients = getPatients()
        for patient in patients {
            if patient.guid == session.patientID{
                return patient
            }
        }
        return nil
    }
}


