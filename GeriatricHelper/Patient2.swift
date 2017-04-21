import UIKit

//an enum that defines a number of weapon options
enum Gender {
    case male, female
}

class Patient2 {
    
    let name: String
    let address: String
    let age: Int
    let gender: Gender
    
    // designated initializer for a Monster
    init(name: String, address: String, age: Int, gender: Gender) {
        self.name = name
        self.address = address
        self.age = age
        self.gender = gender
    }
    
    // Convenience method for fetching a monster's weapon image
    func genderImage() -> UIImage? {
        switch self.gender {
        case .male:
            return UIImage(named: "blowgun.png")
        case .female:
            return UIImage(named: "fire.png")
        }
    }
}
