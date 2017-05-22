//
//  FirebaseDatabaseHelper.swift
//  GeriatricHelper
//
//  Created by felgueiras on 26/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import Foundation


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
     
     
     /**
     * Fetch Sessions from Firebase.
     */
     public static void fetchSessions() {
     FirebaseHelper.firebaseTableSessions.addValueEventListener(new ValueEventListener() {
     
     @Override
     public void onDataChange(DataSnapshot dataSnapshot) {
     Log.d("Firebase","Fetch sessions");
     FirebaseHelper.sessions.clear();
     for (DataSnapshot postSnapshot : dataSnapshot.getChildren()) {
     SessionFirebase session = postSnapshot.getValue(SessionFirebase.class);
     session.setKey(postSnapshot.getKey());
     FirebaseHelper.sessions.add(session);
     }
     }
     
     @Override
     public void onCancelled(DatabaseError databaseError) {
     // Getting Post failed, log a message
     }
     });
     }
     
     /**
     * Fetch Scales from Firebase.
     */
     public static void fetchScales() {
     FirebaseHelper.firebaseTableScales.addValueEventListener(new ValueEventListener() {
     @Override
     public void onDataChange(DataSnapshot dataSnapshot) {
     FirebaseHelper.scales.clear();
     for (DataSnapshot postSnapshot : dataSnapshot.getChildren()) {
     GeriatricScaleFirebase scale = postSnapshot.getValue(GeriatricScaleFirebase.class);
     scale.setKey(postSnapshot.getKey());
     FirebaseHelper.scales.add(scale);
     }
     }
     
     @Override
     public void onCancelled(DatabaseError databaseError) {
     // Getting Post failed, log a message
     }
     });
     }
     
     /**
     * Fetch questions from Firebase.
     */
     public static void fetchQuestions() {
     FirebaseHelper.firebaseTableQuestions.addValueEventListener(new ValueEventListener() {
     @Override
     public void onDataChange(DataSnapshot dataSnapshot) {
     Log.d("Firebase","Fetch questions");
     FirebaseHelper.questions.clear();
     for (DataSnapshot postSnapshot : dataSnapshot.getChildren()) {
     QuestionFirebase question = postSnapshot.getValue(QuestionFirebase.class);
     question.setKey(postSnapshot.getKey());
     FirebaseHelper.questions.add(question);
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
     
     /**
     * Get different session dates (display sessions by date).
     *
     * @return
     */
     public static ArrayList<Date> getDifferentSessionDates() {
     HashSet<Date> days = new HashSet<>();
     for (SessionFirebase session : FirebaseHelper.sessions) {
     Date dateWithoutHour = DatesHandler.getDateWithoutHour(session.getDate());
     days.add(dateWithoutHour);
     }
     ArrayList<Date> differentDates = new ArrayList<>();
     differentDates.addAll(days);
     // order by date (descending)
     Collections.sort(differentDates, new Comparator<Date>() {
     @Override
     public int compare(Date first, Date second) {
     if (first.after(second)) {
     return -1;
     } else if (first.before(second)) {
     return 1;
     } else
     return 0;
     }
     });
     return differentDates;
     
     }
     
     
     public static ArrayList<GeriatricScaleFirebase> getScaleInstancesForPatient(ArrayList<SessionFirebase> patientSessions, String scaleName) {
     ArrayList<GeriatricScaleFirebase> scaleInstances = new ArrayList<>();
     // get instances for that test
     for (SessionFirebase currentSession : patientSessions) {
     List<GeriatricScaleFirebase> scalesFromSession = getScalesFromSession(currentSession);
     for (GeriatricScaleFirebase currentScale : scalesFromSession) {
     if (currentScale.getScaleName().equals(scaleName)) {
     scaleInstances.add(currentScale);
     }
     }
     }
     return scaleInstances;
     }
     
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
     
     /**
     * Update scale.
     *
     * @param currentScale
     */
     public static void updateScale(GeriatricScaleFirebase currentScale) {
     // check if logged in
     FirebaseAuth auth = FirebaseAuth.getInstance();
     if (auth.getCurrentUser() != null) {
     FirebaseHelper.firebaseTableScales.child(currentScale.getKey()).setValue(currentScale);
     }
     }
     
     public static void updateQuestion(QuestionFirebase question) {
     FirebaseAuth auth = FirebaseAuth.getInstance();
     if (auth.getCurrentUser() != null) {
     FirebaseHelper.firebaseTableQuestions.child(question.getKey()).setValue(question);
     }
     }
     
     **/
    
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
    
    static func deleteSession(session:Session) {
     
     // remove session from patient's sessions list (if patient not null)
        
        
        
        
//     var patient = PatientsManagement.getPatientFromSession(session, context);
//     if (patient != null) {
//     patient.getSessionsIDS().remove(session.getGuid());
//                 updatePatient(patient);
//     }
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
     
     public static ArrayList<GeriatricScaleFirebase> getScalesFromSession(SessionFirebase session) {
     FirebaseAuth auth = FirebaseAuth.getInstance();
     if (auth.getCurrentUser() != null) {
     
     ArrayList<String> scalesIDS = session.getScalesIDS();
     ArrayList<GeriatricScaleFirebase> scalesForSession = new ArrayList<>();
     // get scales with those IDS
     
     for (GeriatricScaleFirebase scale : FirebaseHelper.scales) {
     if (scalesIDS.contains(scale.getGuid()))
     scalesForSession.add(scale);
     }
     return scalesForSession;
     
     } else {
     return Constants.publicScales;
     }
     
     }
     
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
     
     /**
     * Get questions from a scale.
     *
     * @param scale
     * @return
     */
     public static ArrayList<QuestionFirebase> getQuestionsFromScale(GeriatricScaleFirebase scale) {
     ArrayList<QuestionFirebase> questionsFromScale = new ArrayList<>();
     ArrayList<QuestionFirebase> questionsToConsider = new ArrayList<>();
     // get scales with those IDS
     FirebaseAuth auth = FirebaseAuth.getInstance();
     if (auth.getCurrentUser() != null) {
     questionsToConsider = FirebaseHelper.questions;
     } else {
     questionsToConsider = Constants.publicQuestions;
     
     }
     
     for (QuestionFirebase question : questionsToConsider) {
     if (question.getScaleID().equals(scale.getGuid())) {
     questionsFromScale.add(question);
     }
     }
     return questionsFromScale;
     }
     
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
