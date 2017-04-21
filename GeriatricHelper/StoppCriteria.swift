import Foundation
import Firebase
import FirebaseDatabase
import ObjectMapper


class StoppCriteria: Mappable {
    
    
    // reference
    var ref: FIRDatabaseReference?
    // key
    var key: String?
    // other attributes
    var category: String?
    var prescriptions: [PrescriptionStopp]?
    
    /**
     Initialize from JSON.
     **/
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    required init?(map: Map) {
        
    }
    
    
    // Mappable - mapping from JSON
    func mapping(map: Map) {
        category  <- map["category"]
        prescriptions  <- map["prescriptions"]
    }
    
    
    
    // initialize GeriatricScale from Firebase snapshot
    init(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        // assign properties
        category = snapshotValue["category"] as! String
        prescriptions = snapshotValue["prescriptions"] as! [PrescriptionStopp]
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "key": key,
            "category": category
        ]
    }
    
}
