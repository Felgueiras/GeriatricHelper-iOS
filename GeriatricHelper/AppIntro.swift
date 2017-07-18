import UIKit
import Onboard

class AppIntro: UIViewController {
    
    let leaveAppIntro = "leaveAppIntro"
   

    override func viewDidAppear(_ animated: Bool) {
        // Initialize onboarding view controller
        var onboardingVC = OnboardingViewController()
        
        // Create slides
        let firstPage = OnboardingContentViewController.content(withTitle: "Bem-vindo ao GeriatricHelper", body: "Esta aplicação permite-lhe aplicar a Avaliação Geriátrica Global (AGG).", image: UIImage(named: "icon_original"), buttonText: nil, action: nil)
        
        let secondPage = OnboardingContentViewController.content(withTitle: "Sessões AGG", body: "Cada AGG é realizada numa sessão, onde as escalas se encontram divididas por área a avaliar (estado funcional, afetivo, cognitivo, nutricional e marcha)", image: UIImage(named: "cga_areas"), buttonText: nil, action: nil)
        
        let thirdPage = OnboardingContentViewController.content(withTitle: "Escalas", body: "À medida que completa as escalas, pode consultar o seu resultado e escrever notas", image: UIImage(named: "image3"), buttonText: nil, action: nil)
        
        let fourthPage = OnboardingContentViewController.content(withTitle: "Rever uma Sessão", body: "Depois de terminada a sessão, pode rever o resultado de cada teste e criar um documento PDF da sessão", image: UIImage(named: "image4"), buttonText: nil, action: nil)
        
        let fifthPage = OnboardingContentViewController.content(withTitle: "Módulos", body: "GeriatricHelper irá suportar módulos. Em versões futuras estes poderão ser ativados e desativados nas Definições da aplicação", image: UIImage(named: "image4"), buttonText: nil, action: nil)
        
        // Define onboarding view controller properties
        onboardingVC = OnboardingViewController.onboard(withBackgroundImage: UIImage(named: "blue"), contents: [firstPage, secondPage, thirdPage, fourthPage, fifthPage])
        onboardingVC.shouldFadeTransitions = true
        onboardingVC.shouldMaskBackground = false
        onboardingVC.shouldBlurBackground = false
        onboardingVC.fadePageControlOnLastPage = false
        //        onboardingVC.pageControl.pageIndicatorTintColor = UIColor.darkGray
        onboardingVC.pageControl.currentPageIndicatorTintColor = UIColor.white
        //        onboardingVC.skipButton.setTitleColor(UIColor.black, for: .normal)
        onboardingVC.allowSkipping = true
        onboardingVC.fadeSkipButtonOnLastPage = false
        
        let controller = self
        onboardingVC.skipHandler = {
//            onboardingVC.dismiss(animated: true, completion: nil)
            controller.performSegue(withIdentifier: self.leaveAppIntro, sender: controller)
        }
        
        // Present presentation
        self.present(onboardingVC, animated: true, completion: nil)
//        onboardingVC.dismiss(animated: true, completion: nil)
//        self.performSegue(withIdentifier: self.leaveAppIntro, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == leaveAppIntro {


//            // pass Session to the destination controller
//            let DestViewController = segue.destination as! UINavigationController
//            let destinationViewController = DestViewController.topViewController as! CGAPublicAreas
//            destinationViewController.session = Constants.cgaPublicSession
        }
    }
   

   
}
