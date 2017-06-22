//
//  FirebaseDatabaseHelper.swift
//  GeriatricHelper
//
//  Created by felgueiras on 26/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase


class FirebaseDatabaseHelper{

/**
     package com.felgueiras.apps.geriatric_helper.Firebase.RealtimeDatabase;
     
     import android.content.Context;
     import android.support.annotation.NonNull;
     import android.util.Log;
     
     import com.felgueiras.apps.geriatric_helper.Constants;
     import com.felgueiras.apps.geriatric_helper.DataTypes.NonDB.ChoiceNonDB;
     import com.felgueiras.apps.geriatric_helper.DataTypes.NonDB.QuestionNonDB;
     import com.felgueiras.apps.geriatric_helper.DataTypes.Scales;
     import com.felgueiras.apps.geriatric_helper.Firebase.FirebaseHelper;
     import com.felgueiras.apps.geriatric_helper.HelpersHandlers.DatesHandler;
     import com.felgueiras.apps.geriatric_helper.PatientsManagement;
     import com.google.android.gms.tasks.OnFailureListener;
     import com.google.android.gms.tasks.OnSuccessListener;
     import com.google.firebase.auth.FirebaseAuth;
     import com.google.firebase.database.DataSnapshot;
     import com.google.firebase.database.DatabaseError;
     import com.google.firebase.database.ValueEventListener;
     import com.google.firebase.storage.FirebaseStorage;
     import com.google.firebase.storage.StorageReference;
     
     import java.util.ArrayList;
     import java.util.Calendar;
     import java.util.Collections;
     import java.util.Comparator;
     import java.util.Date;
     import java.util.HashSet;
     import java.util.List;
     
     /**
     * Created by felgueiras on 15/04/2017.
     */
     
     public class FirebaseDatabaseHelper {
     
     
     /**
     * Get all patients from Firebase.
     *
     * @return
     */
     //    public static void fetchPatients() {
     //
     //        FirebaseHelper.firebaseTablePatients.orderByChild("name").addValueEventListener(new ValueEventListener() {
     //            @Override
     //            public void onDataChange(DataSnapshot dataSnapshot) {
     //                FirebaseHelper.patients.clear();
     //                for (DataSnapshot postSnapshot : dataSnapshot.getChildren()) {
     //                    PatientFirebase patient = postSnapshot.getValue(PatientFirebase.class);
     //                    patient.setKey(postSnapshot.getKey());
     //                    FirebaseHelper.patients.add(patient);
     //                }
     //                Log.d("Fetch", "Patients");
     //            }
     //
     //            @Override
     //            public void onCancelled(DatabaseError databaseError) {
     //                // Getting Post failed, log a message
     //            }
     //        });
     //    }
     
     /**
     * Fetch favorite patients from Firebase.
     *
     * @return
     */
     //    public static void fetchFavoritePatients() {
     //
     //        FirebaseHelper.firebaseTablePatients.orderByChild("favorite").equalTo(true).addValueEventListener(new ValueEventListener() {
     //            @Override
     //            public void onDataChange(DataSnapshot dataSnapshot) {
     //                FirebaseHelper.favoritePatients.clear();
     //                for (DataSnapshot postSnapshot : dataSnapshot.getChildren()) {
     //                    PatientFirebase patient = postSnapshot.getValue(PatientFirebase.class);
     //                    patient.setKey(postSnapshot.getKey());
     //                    FirebaseHelper.favoritePatients.add(patient);
     ////                    Log.d("Firebase", "Patients favorite: " + favoritePatients.size());
     //                    Log.d("Fetch", "Favorite patients");
     //
     //                }
     //            }
     //
     //            @Override
     //            public void onCancelled(DatabaseError databaseError) {
     //                // Getting Post failed, log a message
     //            }
     //        });
     //    }
     
     **/
     
     /**
     * Fetch Sessions from Firebase.
     */
    static func fetchSessions() {
        // reference the user
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        // get all scales scales
        let sessionsRef = FirebaseHelper.ref.child("users").child(userID!).child("sessions")
        sessionsRef.observe(.value, with: { (snapshot) in
            FirebaseHelper.sessions = []
            for item in snapshot.children {
                let session = Session(snapshot: item as! FIRDataSnapshot)
                
                FirebaseHelper.sessions.append(session)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
     /**
     * Fetch Scales from Firebase.
     */
    static func fetchScales() {
        
        // reference the user
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        // get all scales scales
        let scalesRef = FirebaseHelper.ref.child("users").child(userID!).child("scales")
        scalesRef.observe(.value, with: { (snapshot) in
                FirebaseHelper.scales = []
                for item in snapshot.children {
                    let scale = GeriatricScale(snapshot: item as! FIRDataSnapshot)
                    if scale.completed == true{
                        FirebaseHelper.scales.append(scale)
                    }
                }
                
            }) { (error) in
                print(error.localizedDescription)
        }
        
    }
    

    
    /**
     
     @Override
     public void onCancelled(DatabaseError databaseError) {
     // Getting Post failed, log a message
     }
     });
     }
     
     **/
     
    /**
     * Fetch questions from Firebase.
     */
    static func fetchQuestions() {
        
        // reference the user
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        // get all questions
        let scalesRef = FirebaseHelper.ref.child("users").child(userID!).child("questions")
        scalesRef.observe(.value, with: { (snapshot) in
            FirebaseHelper.questions = []
            for item in snapshot.children {
                let question = Question(snapshot: item as! FIRDataSnapshot)
                
                FirebaseHelper.questions.append(question)
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
        /**
     
     }) { (error) in
     print(error.localizedDescription)
     }
     
     }
     
     @Override
     public void onCancelled(DatabaseError databaseError) {
     // Getting Post failed, log a message
     }
     });
     }
     
     
     
     /**
     * Fetch prescriptions from Firebase.
     */
     public static void fetchPrescriptions() {
     FirebaseHelper.firebaseTablePrescriptions.addValueEventListener(new ValueEventListener() {
     @Override
     public void onDataChange(DataSnapshot dataSnapshot) {
     FirebaseHelper.prescriptions.clear();
     for (DataSnapshot postSnapshot : dataSnapshot.getChildren()) {
     PrescriptionFirebase prescription = postSnapshot.getValue(PrescriptionFirebase.class);
     prescription.setKey(postSnapshot.getKey());
     FirebaseHelper.prescriptions.add(prescription);
     }
     }
     
     @Override
     public void onCancelled(DatabaseError databaseError) {
     // Getting Post failed, log a message
     }
     });
     }
     **/
     
     /**
     * Get different session dates (display sessions by date).
     *
     * @return
     */
    static func getDifferentSessionDates() -> [Date] {
        var days = NSMutableSet()
        for  session in FirebaseHelper.sessions {
            var dateWithoutHour = DatesHandler.getDateWithoutHour(date: session.date!)
            days.add(dateWithoutHour);
        }
        var differentDates = Array(days) as! [Date]
     
        // order by date (descending)
        return differentDates;
        
}

    
     
     
//    static func  getScaleInstancesForPatient(patientSessions: [Session],
//                                             scaleName: String) -> [GeriatricScale] {
//        var scaleInstances: [GeriatricScale] = []
//        // get instances for that test
//        for var currentSession in patientSessions {
//            var scalesFromSession: [GeriatricScale] = getScalesFromSession(currentSession);
//            for var currentScale in scalesFromSession {
//                if currentScale.scaleName == scaleName {
//                    scaleInstances.append(currentScale)
//                }
//            }
//        }
//        return scaleInstances;
//    }
    
    
    
    static func  getScaleInstancesForPatient(patientSessions: [Session],
                                             scaleName: String) -> [GeriatricScale] {
        
        var scaleInstances: [GeriatricScale] = []
        // get instances for that test
        for var currentSession in patientSessions {
            var scalesFromSession: [GeriatricScale] = getScalesFromSession(session: currentSession);
            for var currentScale in scalesFromSession {
                if currentScale.scaleName == scaleName {
                    scaleInstances.append(currentScale)
                }
            }
        }
        return scaleInstances;
    }
    
    /**
     
     /**
     * Get sessions from a date.
     *
     * @param firstDay
     * @return
     */
     public static List<SessionFirebase> getSessionsFromDate(Date firstDay) {
     
     Calendar calendar = Calendar.getInstance();
     calendar.setTimeInMillis(firstDay.getTime());
     
     Calendar cal = Calendar.getInstance();
     cal.set(Calendar.YEAR, calendar.get(Calendar.YEAR));
     cal.set(Calendar.MONTH, calendar.get(Calendar.MONTH));
     cal.set(Calendar.DAY_OF_MONTH, calendar.get(Calendar.DAY_OF_MONTH));
     cal.set(Calendar.HOUR_OF_DAY, 0);
     cal.set(Calendar.MINUTE, 0);
     cal.set(Calendar.SECOND, 0);
     // first day
     firstDay = cal.getTime();
     // second day
     cal.set(Calendar.DAY_OF_MONTH, calendar.get(Calendar.DAY_OF_MONTH) + 1);
     Date secondDay = cal.getTime();
     
     //system.out.println("Getting sessions from " + firstDay + "-" + secondDay);
     // TODO get evaluations from that date
     //        return new Select()
     //                .from(Session.class)
     //                .where("date > ? and date < ?", firstDay.getTime(), secondDay.getTime())
     //                .orderBy("guid ASC")
     //                .execute();
     return FirebaseHelper.sessions;
     }
     
     
    **/
    
    
    static func createScale(scale:GeriatricScale) {
        // create reference to new scale
        let scaleRef = FirebaseHelper.ref.child(FirebaseHelper.scalesReferencePath).childByAutoId()
        let scaleKey = scaleRef.key
        scale.key = scaleKey
        // add to firebase
        scaleRef.setValue(scale.toAnyObject())
    }
    
    
     
     /**
     * Update scale.
     *
     * @param currentScale
     */
    static func updateScale(scale: GeriatricScale) {
        // check if logged in
//        FirebaseAuth auth = FirebaseAuth.getInstance();
//        if (auth.getCurrentUser() != null) {
        FirebaseHelper.ref.child(FirebaseHelper.scalesReferencePath).child(scale.key!).setValue(scale.toAnyObject())
//        }
    }
    
   
     
    static func updateQuestion(question: Question) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        if userID != nil {
            FirebaseHelper.ref.child(FirebaseHelper.questionsReferencePath).child(question.key!).setValue(question.toAnyObject())
        }
    }
    
    static func updateSession(session:Session) {
        FirebaseHelper.ref.child(FirebaseHelper.sessionsReferencePath).child(session.key!).setValue(session.toAnyObject())
    }
    
    /**
     
     public static ArrayList<GeriatricScaleFirebase> getScalesForArea(List<GeriatricScaleFirebase> scales, String area) {
     ArrayList<GeriatricScaleFirebase> scalesForArea = new ArrayList<>();
     for (GeriatricScaleFirebase scale : scales) {
     if (Scales.getScaleByName(scale.getScaleName()).getArea().equals(area)) {
     scalesForArea.add(scale);
     }
     }
     return scalesForArea;
     }
     
     
     **/
    // TODo
    static func deleteSession(session:Session,
                              patient: Patient) {
        
        
        if let itemToRemoveIndex = patient.sessionsIDS.index(of: session.guid!) {
            patient.sessionsIDS.remove(at: itemToRemoveIndex)
        }
        
        PatientsManagement.updatePatient(patient: patient)
        
        
        // remove session
        session.ref?.removeValue()

//        
//        public static PatientFirebase getPatientFromSession(SessionFirebase session, Context context) {
//            FirebaseAuth auth = FirebaseAuth.getInstance();
//            if (auth.getCurrentUser() == null) {
//                return null;
//            }
//            if (session.getPatientID() == null) {
//                return null;
//            }
//            ArrayList<PatientFirebase> patients = getPatients(context);
//            for (PatientFirebase patient : patients) {
//                if (patient.getGuid().equals(session.getPatientID()))
//                return patient;
//            }
//            return null;
//        }

    }
    
    /**
     
     // delete scales
     ArrayList<GeriatricScaleFirebase> scales = getScalesFromSession(session);
     for (GeriatricScaleFirebase scale : scales) {
     deleteScale(scale);
     }
     
     FirebaseHelper.firebaseTableSessions.child(session.getKey()).removeValue();
     }
     
     
     /**
     * Erase uncompleted scales from a session.
     *
     * @param session
     */
     public static void eraseScalesNotCompleted(SessionFirebase session) {
     FirebaseAuth auth = FirebaseAuth.getInstance();
     if (auth.getCurrentUser() != null) {
     // logged in - erase from Firebase
     List<GeriatricScaleFirebase> scales = getScalesFromSession(session);
     for (GeriatricScaleFirebase scale : scales) {
     if (!scale.isCompleted()) {
     deleteScale(scale);
     }
     }
     } else {
     // not logged in - erase from Constants
     ArrayList<GeriatricScaleFirebase> completedScales = new ArrayList<>();
     for (GeriatricScaleFirebase scale : Constants.publicScales) {
     if (scale.isCompleted()) {
     completedScales.add(scale);
     }
     }
     Constants.publicScales = completedScales;
     }
     }
     
     /**
     * Delete a scale from Firebase.
     *
     * @param scale
     */
     public static void deleteScale(GeriatricScaleFirebase scale) {
     
     // remove from the session's list of scales IDs
     SessionFirebase session = getSessionFromScale(scale);
     if (session != null) {
     session.getScalesIDS().remove(scale.getGuid());
     updateSession(session);
     }
     
     // delete questions
     ArrayList<QuestionFirebase> questions = getQuestionsFromScale(scale);
     for (QuestionFirebase question : questions) {
     deleteChoice(question);
     }
     
     // remove associated images or videos
     if (scale.isContainsPhoto()) {
     Log.d("Firebase", "Removing photo");
     FirebaseStorage storage = FirebaseStorage.getInstance();
     // photo reference
     StorageReference storageRef = storage.getReferenceFromUrl("gs://appprototype-bdd27.appspot.com")
     .child("users/" + FirebaseAuth.getInstance().getCurrentUser().getUid() + "/images/" + scale.getPhotoPath());
     
     // Delete the file
     storageRef.delete().addOnSuccessListener(new OnSuccessListener<Void>() {
     @Override
     public void onSuccess(Void aVoid) {
     // File deleted successfully
     Log.d("Firebase", "Photo deleted!");
     
     }
     }).addOnFailureListener(new OnFailureListener() {
     @Override
     public void onFailure(@NonNull Exception exception) {
     // Uh-oh, an error occurred!
     }
     });
     }
     if (scale.isContainsVideo()) {
     
     }
     
     // remove scale
     FirebaseHelper.firebaseTableScales.child(scale.getKey()).removeValue();
     }
     
     
     public static void deleteChoice(QuestionFirebase choide) {
     
     // remove choice
     FirebaseHelper.firebaseTableChoices.child(choide.getKey()).removeValue();
     }
     
     
     **/
    
     /**
     * Delete a prescription.
     *
     * @param prescription
     * @param context
     */
    static func deletePrescription(prescription: Prescription,
                                   patient: Patient) {
        
        // remove from patient's list of prescriptions
//        PatientFirebase patient = PatientsManagement.getPatientFromPrescription(prescription, context);
        if let itemToRemoveIndex = patient.prescriptionsIDS.index(of: prescription.guid!) {
            patient.prescriptionsIDS.remove(at: itemToRemoveIndex)
        }
        
        PatientsManagement.updatePatient(patient: patient)
    
        
        // remove prescription
        prescription.ref?.removeValue()
    }
    
    /**
     
     /**
     * Get sessions from patient.
     *
     * @param patient
     * @return
     */
     public static ArrayList<SessionFirebase> getSessionsFromPatient(PatientFirebase patient) {
     
     final ArrayList<SessionFirebase> patientSessions = new ArrayList<>();
     
     for (SessionFirebase session: FirebaseHelper.sessions) {
     if(session.getPatientID().equals(patient.getGuid()))
     patientSessions.add(session);
     }
     return patientSessions;
     }
     
     /**
     * Get prescription from patient.
     *
     * @param patient
     * @return
     */
     public static ArrayList<PrescriptionFirebase> getPrescriptionsFromPatient(PatientFirebase patient) {
     ArrayList<String> prescriptionsIDS = patient.getPrescriptionsIDS();
     final ArrayList<PrescriptionFirebase> prescriptionsForPatient = new ArrayList<>();
     
     for (int i = 0; i < prescriptionsIDS.size(); i++) {
     String currentID = prescriptionsIDS.get(i);
     prescriptionsForPatient.add(getPrescriptionByID(currentID));
     }
     return prescriptionsForPatient;
     }
     
     /**
     * Get a scale by its ID.
     *
     * @param scaleID
     * @return
     */
     public static GeriatricScaleFirebase getScaleByID(String scaleID) {
     
     for (GeriatricScaleFirebase scale : FirebaseHelper.scales) {
     if (scale.getGuid().equals(scaleID))
     return scale;
     }
     return null;
     }
     
     public static SessionFirebase getSessionByID(String sessionID) {
     
     for (SessionFirebase session : FirebaseHelper.sessions) {
     if (session.getGuid().equals(sessionID))
     return session;
     }
     return null;
     }
     
     public static PrescriptionFirebase getPrescriptionByID(String prescriptionID) {
     
     for (PrescriptionFirebase prescription : FirebaseHelper.prescriptions) {
     if (prescription.getGuid().equals(prescriptionID))
     return prescription;
     }
     return null;
     }
     
     /**
     * Get a Question by its ID.
     *
     * @param questionID
     * @return
     */
     public static QuestionFirebase getQuestionByID(String questionID) {
     
     ArrayList<QuestionFirebase> questionsToConsider = new ArrayList<>();
     // get scales with those IDS
     FirebaseAuth auth = FirebaseAuth.getInstance();
     if (auth.getCurrentUser() != null) {
     questionsToConsider = FirebaseHelper.questions;
     } else {
     questionsToConsider = Constants.publicQuestions;
     
     }
     for (QuestionFirebase question : questionsToConsider) {
     if (question.getGuid().equals(questionID))
     return question;
     }
     return null;
     }
     
     /**
     * Get a scale from a session by its name.
     *
     * @param session
     * @param scaleName
     * @return
     */
     public static GeriatricScaleFirebase getScaleFromSession(SessionFirebase session, String scaleName) {
     
     FirebaseAuth auth = FirebaseAuth.getInstance();
     if (auth.getCurrentUser() != null) {
     ArrayList<String> scalesIDS = session.getScalesIDS();
     // get scales with those IDS
     
     for (GeriatricScaleFirebase scale : FirebaseHelper.scales) {
     if (scalesIDS.contains(scale.getGuid()) && scale.getScaleName().equals(scaleName))
     return scale;
     }
     return null;
     } else {
     // public session
     for (GeriatricScaleFirebase scale : Constants.publicScales) {
     if (scale.getScaleName().equals(scaleName)) {
     return scale;
     }
     }
     }
     
     return null;
     }
     **/
     
    static func  getScalesFromSession(session: Session) -> [GeriatricScale]{
        
        let scalesIDS = session.scalesIDS
        var  scalesForSession:[GeriatricScale] = []
        
        // get scales with those IDS
        for var scale in FirebaseHelper.scales {
            if scalesIDS.contains( scale.guid! ) {
                
                scalesForSession.append(scale)
            }
            
        }
        return scalesForSession
        
        
    }
    
    /**
     
     public static SessionFirebase getSessionFromScale(GeriatricScaleFirebase scale) {
     FirebaseAuth auth = FirebaseAuth.getInstance();
     if (auth.getCurrentUser() != null) {
     for (SessionFirebase session : FirebaseHelper.sessions) {
     if (session.getGuid().equals(scale.getSessionID())) {
     return session;
     }
     }
     } else {
     return Constants.publicSession;
     }
     
     return null;
     
     }
     
     **/
     
     /**
     * Get questions from a scale.
     *
     * @param scale
     * @return
     */
    static func getQuestionsFromScale(scale:GeriatricScale) -> [Question] {
//        ArrayList<QuestionFirebase> questionsFromScale = new ArrayList<>();
//        ArrayList<QuestionFirebase> questionsToConsider = new ArrayList<>();
//        // get scales with those IDS
//        FirebaseAuth auth = FirebaseAuth.getInstance();
//        if (auth.getCurrentUser() != null) {
//            questionsToConsider = FirebaseHelper.questions;
//        } else {
//            questionsToConsider = Constants.publicQuestions;
//            
//        }
        
 
        

        var  questions:[Question] = []
        
        // get scales with those IDS
        for var question in FirebaseHelper.questions {
            if question.scaleID == scale.guid{
                
                questions.append(question)
            }
            
        }
        return questions
    }
    
    /**
     
     /**
     * Get Choices for a Question.
     *
     * @param question
     * @return
     */
     public static ArrayList<ChoiceNonDB> getChoicesForQuestion(QuestionNonDB question) {
     ArrayList<ChoiceFirebase> choicesForQuestion = new ArrayList<>();
     ArrayList<ChoiceNonDB> choicesToConsider;
     
     FirebaseAuth auth = FirebaseAuth.getInstance();
     //        if (auth.getCurrentUser() != null) {
     choicesToConsider = question.getChoices();
     //        } else {
     //            choicesToConsider = Constants.publicChoices;
     //
     //        }
     
     //        for (ChoiceFirebase choice : choicesToConsider) {
     //            if (choice.getQuestionID().equals(question.getGuid())) {
     //                choicesForQuestion.add(choice);
     //            }
     //        }
     return choicesToConsider;
     }
     
     public static void createPrescription(PrescriptionFirebase prescription) {
     String prescriptionID = FirebaseHelper.firebaseTablePrescriptions.push().getKey();
     prescription.setKey(prescriptionID);
     FirebaseHelper.firebaseTablePrescriptions.child(prescriptionID).setValue(prescription);
     }
     
    **/
    
    /**
     Add Session to Firebase
 **/
    static func createSession(session:Session) {        
        // create reference to new session
        let sessionref = FirebaseHelper.ref.child(FirebaseHelper.sessionsReferencePath).childByAutoId()
        let sessionKey = sessionref.key
        session.key = sessionKey
        // add to firebase
        sessionref.setValue(session.toAnyObject())
    }
    
    /**
     Add Prescription to Firebase
 **/
    static func createPrescription(prescription:Prescription) {
        // create reference to new session
        let prescriptionRef = FirebaseHelper.ref.child(FirebaseHelper.prescriptionsReferencePath).childByAutoId()
        let prescriptionKey = prescriptionRef.key
        prescription.key = prescriptionKey
        // add to firebase
        prescriptionRef.setValue(prescription.toAnyObject())
    }
    
 
     
    
    static func createQuestion(question: Question) {
        // create reference to new session
        let questionref = FirebaseHelper.ref.child(FirebaseHelper.questionsReferencePath).childByAutoId()
        let questionKey = questionref.key
        question.key = questionKey
        // add to firebase
        questionref.setValue(question.toAnyObject())
    }

 

}
