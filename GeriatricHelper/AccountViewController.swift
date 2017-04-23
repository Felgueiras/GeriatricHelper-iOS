import UIKit
import FirebaseAuth
import FirebaseStorage
import ObjectMapper

class AccountViewController: UIViewController {
    

    
    
    @IBAction func signOut(_ sender: Any) {
        print("123")
        do {
            try        FIRAuth.auth()!.signOut()
            print("Sining out")
        } catch {
            print("Error: \(error)")
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
}
