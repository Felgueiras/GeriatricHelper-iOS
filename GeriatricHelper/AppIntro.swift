import UIKit
import Onboard

class AppIntro: OnboardingViewController {
   
   override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
   }
   
   // MARK: Initializers
   
   required init?(coder aDecoder: NSCoder) {
    
    let firstPageTitle = "Bem-vindo ao GeriatricHelper"
    let secondPageTitle = "Área Pessoal"
    let thirdPageTitle = "Prescrição"
    
    let firstPageText = "Esta aplicação permite-lhe aplicar a Avaliação Geriátrica Global."
    let secondPageText = "Ao registar-se na aplicação pode gerir os seus pacientes, avalià-los e acompanhar o seu progresso."
    let thirdPageText = "Consulte critérios que o ajudarão a prescrever o medicamento mais apropriado para os seus pacientes."
    
    let firstPage = OnboardingContentViewController(title: firstPageTitle,
                                                    body: firstPageText,
                                                    image: #imageLiteral(resourceName: "icon_small"),
                                                    buttonText: nil) { () -> Void in
    }
    
    let secondPage = OnboardingContentViewController(title: secondPageTitle,
                                                     body: secondPageText, image: #imageLiteral(resourceName: "icon_small"), buttonText: nil) { () -> Void in
    }
    
    let thirdPage = OnboardingContentViewController(title: thirdPageTitle,
                                                    body: thirdPageText,
                                                    image: #imageLiteral(resourceName: "icon_small"),
                                                    buttonText: "Começar") { () -> Void in
                                                      
//                                                        self.performSegue(withIdentifier: "showAppIntro", sender: self)
                                                        
    }
    
      super.init(coder: aDecoder)
    
      self.viewControllers = [firstPage, secondPage, thirdPage]
      
      // Customize Onboard viewController
      allowSkipping = true
      skipHandler = {
        self.performSegue(withIdentifier: "leaveAppIntro", sender: self)
    }
      
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
}
