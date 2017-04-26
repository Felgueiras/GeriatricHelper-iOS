import UIKit
import FirebaseAuth
import FirebaseStorage
import ObjectMapper

class LoginViewController: UIViewController {
    
    // MARK: Constants
    let loginToList = "LoginToList"
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    // MARK: Actions
    // do login
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        // sign in using Firebase
        FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!,
                               password: textFieldLoginPassword.text!)
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
                                    print("appending to stopp")
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
    
    //TODO remove this one
    func downloadScales(){
        // fetch scales
        // fetch scales from storage
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://appprototype-bdd27.appspot.com")
        let scalesRef = storageRef.child("scales")
        
        print("Going to load scales")
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
                    // Data for "images/island.jpg" is returned
                    // ... let islandImage: UIImage! = UIImage(data: data!)
                    
                    
                    // parse to JSON
                    do {
                        
                        if let ipString = NSString(data:data!, encoding: String.Encoding.utf8.rawValue) {
                            
                            let scale = Mapper<GeriatricScale>().map(JSONString: String(describing: ipString))
                            // save scale to Constants
                            Constants.scales.append(scale!)
                            
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
    
        
        // 1 - add a state change listener for auth.
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2 - if a user is logged in, or upon log in ---
            if user != nil {
                
                
                
                
                
                
                // 3 --- perform a segue
                self.performSegue(withIdentifier: "mySegueIdentifier", sender: nil)
            }
        }
    }
    
    // register
    @IBAction func signUpDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Registar",
                                      message: nil,
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Registar",
                                       style: .default) { action in
                                        
                                        // 1 - get email and password
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        
                                        // 2 - create user
                                        FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                                                   password: passwordField.text!) { user, error in
                                                                    if error == nil {
                                                                        // 3 - sign in (if no errors)
                                                                        FIRAuth.auth()!.signIn(withEmail: self.textFieldLoginEmail.text!,
                                                                                               password: self.textFieldLoginPassword.text!)
                                                                    }
                                        }
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .default)
        // add text fields to alert action        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldLoginEmail {
            textFieldLoginPassword.becomeFirstResponder()
        }
        if textField == textFieldLoginPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    

    
}
