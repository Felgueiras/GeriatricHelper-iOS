import UIKit
import FirebaseAuth
import FirebaseStorage
import ObjectMapper

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
                
                // call segue
                performSegue(withIdentifier: SegueLeaveInitialSetup, sender: self)
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
        
        let scales = ["Escala de Katz-PT", "Recursos sociales-ES",
                      "Valoración Socio-Familiar de Gijón-ES",
                      "Barthel Index-ES", "Classificaçao Funcional da Marcha de Holden-PT",
                      "Clock drawing test-EN","Escala de Depressão Geriátrica de Yesavage – versão curta-PT",
                      "Escala de Lawton & Brody-PT","Escala de Tinetti-PT",
                      "Mini mental state examination (Folstein)-PT","Mini nutritional assessment - avaliação global-PT",
                      "Mini nutritional assessment - triagem-PT",""]
        
        // fetch every scale
        for scaleName in scales {
            // create reference to file
            let scaleRef = scalesRef.child(scaleName+fileType)
            //            print(scaleRef.fullPath)
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            scaleRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // check if first start
        let defaults = UserDefaults.standard
        let HasLaunchedOnce = defaults.bool(forKey: "HasLaunchedOnce")
//        if !HasLaunchedOnce{
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
            
            downloadCriteria()
            
            downloadScales()
            defaults.set(true, forKey: "HasLaunchedOnce")
//        }
//        else{
//            // read from defaults and add to Constants
//            let decoded  = defaults.object(forKey: "scales") as! Data
//            let decodedScales = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [GeriatricScale]
//            Constants.scales = decodedScales
//            
//            // call segue
//            print("calling segue")
//            performSegue(withIdentifier: SegueLeaveInitialSetup, sender: self)
//        }
    

    }
    
}
