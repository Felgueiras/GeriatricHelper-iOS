
import Foundation
import Firebase
import FirebaseDatabase
import ObjectMapper


class PrescriptionStopp: Mappable {
    
    // reference
    var ref: FIRDatabaseReference?
    // key
    var key: String?
    // other attributes
    var drugName: String?
    var situations: [Issue]?
    
    /**
     Initialize from JSON.
     **/
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    required init?(map: Map) {
        
    }
    
    
    // Mappable - mapping from JSON
    func mapping(map: Map) {
        drugName  <- map["drugName"]
        situations  <- map["situations"]
    }
    
    
    
    // initialize GeriatricScale from Firebase snapshot
    init(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        // assign properties
        drugName = snapshotValue["drugName"] as! String
        situations = snapshotValue["situations"] as! [Issue]
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "key": key,
            "drugName": drugName
        ]
    }
    
}
