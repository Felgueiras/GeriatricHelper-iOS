import UIKit
import FirebaseAuth
import FirebaseStorage
import ObjectMapper
import Onboard

class InitialSetup: UIViewController {
    
    // segue to leave the initial setup area
    let SegueLeaveInitialSetup = "leaveInitialSetup"
    
    // total number of scales
    let scalesTotal:Float = 12.0
    
    // display loading progress
    @IBOutlet weak var progressView: UIProgressView!
    
    // number of downloaded scales
    var downloadedScales:Int = 0 {
        didSet {
            let fractionalProgress = Float(downloadedScales) / scalesTotal
            let animated = downloadedScales != 0
            
            progressView.setProgress(fractionalProgress, animated: animated)
            //            progressLabel.text = ("\(counter)%")
            if(downloadedScales == Int(scalesTotal)){
                print("Every Scale downloaded")
                
                
                
                
                self.performSegue(withIdentifier: "showAppIntro", sender: self)
            }
        }
    }
    
    // download Start and Stopp criteria
    func downloadCriteria(){
        // fetch criteria from storage
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://appprototype-bdd27.appspot.com")
        let criteriaRef = storageRef.child("criteria")
        
        print("Going to load criteria")
        let fileType = ".json"
        
        let criteriaFiles = ["start",
                             "stopp"]
        
        // fetch every scale
        for criteriaFile in criteriaFiles {
            // create reference to file
            let criteria = criteriaRef.child(criteriaFiles.first!+fileType)
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            criteria.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                } else {
                    // Data for "images/island.jpg" is returned
                    // ... let islandImage: UIImage! = UIImage(data: data!)
                    
                    
                    // parse to JSON
                    do {
                        
                        if let criteriaString = NSString(data:data!, encoding: String.Encoding.utf8.rawValue) {
                            if(criteriaFile == "start"){
                                let criteriaList: Array<StartCriteria> = Mapper<StartCriteria>().mapArray(JSONString: (criteriaString as String) as String)!
                                // save scale to Constants
                                for cr in criteriaList{
                                    Constants.startCriteria.append(cr)
                                }
                            } else if criteriaFile == "stopp"{
                                let criteriaList: Array<StoppCriteria> = Mapper<StoppCriteria>().mapArray(JSONString: (criteriaString as String) as String)!
                                for cr in criteriaList{
                                    Constants.stoppCriteria.append(cr)
                                }
                                
                            }
                            
                        }
                    }
                    catch {
                        print("Error: \(error)")
                    }
                }
            }
            
        }
        
    }
    
    
    /**
     Download scales if needed.
 **/
    func downloadScales(){
        // TODO fetch only for the first time or when there is a new version
        
        // fetch scales from storage
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://appprototype-bdd27.appspot.com")
        let scalesRef = storageRef.child("scales")
        
        let fileType = ".json"
        
        // TODO go to DB and get only the scales from there
        let scales = ["Escala de Katz-PT",
//                      "Recursos sociales-ES",
//                      "Valoración Socio-Familiar de Gijón-ES",
//                      "Barthel Index-ES",
                      "Classificaçao Funcional da Marcha de Holden-PT",
//                      "Clock drawing test-EN",
                      "Escala de Depressão Geriátrica de Yesavage – versão curta-PT",
                      "Escala de Lawton & Brody-PT",
//                      "Escala de Tinetti-PT",
                      "Mini mental state examination (Folstein)-PT",
                      "Mini nutritional assessment - avaliação global-PT",
                      "Mini nutritional assessment - triagem-PT",""]
        
        // fetch every scale
        for scaleName in scales {
            // create reference to file
            let scaleRef = scalesRef.child(scaleName+fileType)
            //            print(scaleRef.fullPath)
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            scaleRef.data(withMaxSize: 4 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                } else {
                    self.downloadedScales += 1
                    
                    // parse to JSON
                    do {
                        
                        if let ipString = NSString(data:data!, encoding: String.Encoding.utf8.rawValue) {
                            
                            let scale = Mapper<GeriatricScale>().map(JSONString: String(describing: ipString))
                            // save scale to Constants
                            Constants.scales.append(scale!)
                            
                            
                            // write to defaults
                            let defaults = UserDefaults.standard
                            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: Constants.scales)
                            defaults.set(encodedData, forKey: "scales")
                            defaults.synchronize()
                            
                            // read from defaults
                            let decoded  = defaults.object(forKey: "scales") as! Data
                            let decodedScales = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [GeriatricScale]
                        
                            
                        }
                    }
                    catch {
                        print("Error: \(error)")
                    }
                }
            }
            
            
        }
        
        
        
    }
    
    
    /**
     func downloadScales2() {
        
     
     // download scales from that language
     GsonBuilder builder = new GsonBuilder();
     builder.excludeFieldsWithModifiers(Modifier.FINAL, Modifier.TRANSIENT, Modifier.STATIC).setPrettyPrinting();
     final Gson gson = builder.create();
     
     final FirebaseStorage storage = FirebaseStorage.getInstance();
     // clear the scales
     Scales.scales.clear();
     SharedPreferencesHelper.resetScales(context);
     FirebaseHelper.scalesCurrent = 0;
     
     // default system language
     final String displayLanguage = Locale.getDefault().getLanguage().toLowerCase();
     
     
     // fetch every existing scale
     firebaseTablePublic.child("scales").orderByChild("name").addValueEventListener(new ValueEventListener() {
     @Override
     public void onDataChange(DataSnapshot dataSnapshot) {
     FirebaseHelper.scales.clear();
     for (DataSnapshot postSnapshot : dataSnapshot.getChildren()) {
     ScaleMetadata scale = postSnapshot.getValue(ScaleMetadata.class);
     scale.setKey(postSnapshot.getKey());
     //                    Log.d("Scales", scale.getLanguages().size() + "");
     
     final String scaleName = scale.getName();
     String scaleLanguage = null;
     
     // check if we have the scale version for this language
     if (scale.getLanguages().contains(displayLanguage)) {
     Log.d("Scales", "Language match " + scale.getName());
     scaleLanguage = displayLanguage.toUpperCase();
     
     } else {
     Log.d("Scales", "Language mismatch " + scale.getName());
     if (scale.getLanguages().size() == 1) {
     // only one available language
     scaleLanguage = scale.getLanguages().get(0).toUpperCase();
     } else {
     // multiple languages
     if (scale.getLanguages().contains("en")) {
     // english is available
     scaleLanguage = "en";
     } else {
     // return first one
     scaleLanguage = scale.getLanguages().get(0);
     }
     
     }
     }
     String fileName = scaleName + "-" + scaleLanguage + ".json";
     
     StorageReference storageRef = storage.getReferenceFromUrl(FirebaseHelper.firebaseURL).child("scales/" + fileName);
     
     try {
     final File localFile = File.createTempFile("scale", "json");
     storageRef.getFile(localFile).addOnSuccessListener(new OnSuccessListener<FileDownloadTask.TaskSnapshot>() {
     @Override
     public void onSuccess(FileDownloadTask.TaskSnapshot taskSnapshot) {
     try {
     Log.d("Scales", "Downloaded " + scaleName);
     GeriatricScaleNonDB scaleNonDB = gson.fromJson(new FileReader(localFile), GeriatricScaleNonDB.class);
     // save to shared preferences
     SharedPreferencesHelper.addScale(scaleNonDB, context);
     Scales.scales.add(scaleNonDB);
     FirebaseHelper.scalesCurrent++;
     if (FirebaseHelper.scalesCurrent == FirebaseHelper.scalesTotal)
     FirebaseHelper.canLeaveLaunchScreen = true;
     } catch (FileNotFoundException e) {
     e.printStackTrace();
     }
     }
     }).addOnFailureListener(new OnFailureListener() {
     @Override
     public void onFailure(@NonNull Exception exception) {
     if (exception instanceof com.google.firebase.storage.StorageException) {
     // scale was not found for that language
     }
     FirebaseHelper.scalesCurrent++;
     if (FirebaseHelper.scalesCurrent == FirebaseHelper.scalesTotal)
     FirebaseHelper.canLeaveLaunchScreen = true;
     }
     });
     } catch (Exception e) {
     e.printStackTrace();
     
     }
     }
     Log.d("Fetch", "Patients");
     }
     
     @Override
     public void onCancelled(DatabaseError databaseError) {
     // Getting Post failed, log a message
     }
     });
     
     // get system language
     //        final String scaleLanguage = Locale.getDefault().getLanguage().toUpperCase();
     
     
     }
 **/
 
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // init RemoteConfig
        FirebaseRemoteConfig().initRemoteConfig()
        
        // test localization
        let welcomeMessage = NSLocalizedString("Welcome", comment: "")
        print(welcomeMessage)
        
        
        // check if first start
        let defaults = UserDefaults.standard
        let HasLaunchedOnce = defaults.bool(forKey: "HasLaunchedOnce")
        if !HasLaunchedOnce{
            // start the counter
            for _ in 0..<100 {
                DispatchQueue.global(qos: .background).async {
                    sleep(1)
                    DispatchQueue.main.async {
                        //                    self.counter += 1
                        return
                    }
                }
            }
            // download scales and criteria
            
//            downloadCriteria()
            
            downloadScales()
            defaults.set(true, forKey: "HasLaunchedOnce")
            
            
            
           
            
        }
        else{
            // read from defaults and add to Constants
            let decoded  = defaults.object(forKey: "scales") as! Data
            let decodedScales = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [GeriatricScale]
            Constants.scales = decodedScales
            
            // check if user is already logged in
            FIRAuth.auth()!.addStateDidChangeListener { auth, user in
                guard user != nil else {
                    
                    // not logged in
                    self.performSegue(withIdentifier: self.SegueLeaveInitialSetup, sender: self)
                    return
                }
                
                // save user ID
                FirebaseHelper.userID = FIRAuth.auth()?.currentUser?.uid
                
                // load questions
                FirebaseDatabaseHelper.fetchQuestions()
                // load scales
                FirebaseDatabaseHelper.fetchScales()
                // load sessions
                FirebaseDatabaseHelper.fetchSessions()
                
                // navigate automatically to the private area
                self.performSegue(withIdentifier: "NavigatePersonalArea", sender: self)
                
                
                
            }
            
        }
        
        
    

    }
    
}
