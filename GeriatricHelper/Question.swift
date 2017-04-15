import Foundation
import Firebase
import FirebaseDatabase
    

struct Question {
    
    /**
     answerNumber:
     answered:
     choicesIDs:
     description:
     guid:
     key:
     multipleTextInput:
     noValue:
     numerical:
     rightWrong:
     scaleID:
     selectedChoice:
     yesOrNo:
     yesValue:

 
 **/

    // reference
    let ref: FIRDatabaseReference?
    // key
    let key: String
    // other attributes
    let answerNumber: Int
    let answered: Bool
//    let choicesIDs: Bool
    let description: String
    let guid: String
    let selectedChoice: String

    
    
    // initialize GeriatricScale from snapshot
    init(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        // assign properties
        answerNumber = snapshotValue["answerNumber"] as! Int
        answered = snapshotValue["answered"] as! Bool
        description = snapshotValue["description"] as! String
        guid = snapshotValue["guid"] as! String
        selectedChoice = snapshotValue["selectedChoice"] as! String
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "key": key,
            "description": description,
            "guid": guid,
            "selectedChoice": selectedChoice,
            "answerNumber": answerNumber,
        ]
    }
    
}
