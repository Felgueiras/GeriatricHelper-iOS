import Foundation
import Firebase
import FirebaseDatabase
import ObjectMapper


class StartCriteria: Mappable {
    
    /***
     {
     "category": "Endocrine System",
     "prescriptions": [
     {
     "description": "Metformin with type 2 diabetes +/- metabolic syndrome(in the absence of renal impairment—estimated GFR \u003c50ml/ min).",
     "drugName": "Metformin"
     },
     {
     "description": "in diabetes with nephropathy i.e. overt urinalysis proteinuria or micoralbuminuria (\u003e30mg/24 hours) +/- serum biochemical renal impairment—estimated GFR \u003c50ml/min.",
     "drugName": "ACE inhibitor or Angiotensin Receptor Blocker"
     },
     {
     "description": "in diabetes mellitus if one or more co-existing major cardiovascular risk factor present (hypertension, hypercholesterolaemia, smoking history).",
     "drugName": "Antiplatelet therapy"
     },
     {
     "description": "Statin therapy in diabetes mellitus if one or more co-existing major cardiovascular risk factor present",
     "drugName": "Statin"
     }
     ]
     },
     **/
    
    // reference
    var ref: FIRDatabaseReference?
    // key
    var key: String?
    // other attributes
    var category: String?
    var prescriptions: [PrescriptionStart]?
    
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
        prescriptions = snapshotValue["prescriptions"] as! [PrescriptionStart]
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "key": key,
            "category": category
        ]
    }
    
}
