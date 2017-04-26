import UIKit
import FirebaseAuth
import FirebaseStorage
import ObjectMapper

class AccountViewController: UIViewController {
    

    
    // sign out
    @IBAction func signOut(_ sender: Any) {
        
        let alert = UIAlertController(title: "Logout",
                                      message: "Deseja mesmo fazer log out",
                                      preferredStyle: .alert)
        
        
        // cancel the current session
        let saveAction = UIAlertAction(title: "Sim",
                                       style: .default) { _ in
                                        
                                        // prompt if really wants to log out
                                        
                                        do {
                                            try        FIRAuth.auth()!.signOut()
                                            self.performSegue(withIdentifier: "LogOutSegue", sender: self)
                                            print("Sining out")
                                        } catch {
                                            print("Error: \(error)")
                                        }
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Não",
                                         style: .default)
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
}
