import Foundation
import Firebase
import FirebaseDatabase
import ObjectMapper


class PrescriptionStart: Mappable {
    
    /***
    
     {
     "description": "Metformin with type 2 diabetes +/- metabolic syndrome(in the absence of renal impairment—estimated GFR \u003c50ml/ min).",
     "drugName": "Metformin"
     }
     **/
    
    // reference
    var ref: FIRDatabaseReference?
    // key
    var key: String?
    // other attributes
    var description: String?
    var drugName: String?
    
    /**
     Initialize from JSON.
     **/
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    required init?(map: Map) {
        
    }
    
    
    // Mappable - mapping from JSON
    func mapping(map: Map) {
        description  <- map["description"]
        drugName  <- map["drugName"]
    }
    
    
    
    // initialize GeriatricScale from Firebase snapshot
    init(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        // assign properties
        description = snapshotValue["description"] as! String
        drugName = snapshotValue["drugName"] as! String
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "key": key,
            "description": description
        ]
    }
    
}
