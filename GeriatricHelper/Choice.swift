import Foundation
import Firebase
import FirebaseDatabase
import ObjectMapper


class Choice: NSObject, Mappable, NSCoding {
    
    
    // reference
    var ref: FIRDatabaseReference?
    // key
    var key: String?
    // other attributes
    var name: String?
    var descriptionText: String?
    var score: Double?
    var yes: Int?
    var no: Int?
    
    
    // decode
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as? String
        let descriptionText = aDecoder.decodeObject(forKey: "description") as? String
        let score = aDecoder.decodeObject(forKey: "score") as! Double
        let yes = aDecoder.decodeObject(forKey: "yes") as! Int
        let no = aDecoder.decodeObject(forKey: "no") as! Int
        self.init(name: name,
                  descriptionText: descriptionText,
                  score: score,
                  yes: yes,
                  no: no)
    }
    
    // encode
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(descriptionText, forKey: "description")
        aCoder.encode(score, forKey: "score")
        aCoder.encode(yes, forKey: "yes")
        aCoder.encode(no, forKey: "no")
    }
    
    init(name: String?,
         descriptionText: String?,
         score: Double,
         yes: Int,
         no: Int) {
        self.name = name
        self.descriptionText = descriptionText
        self.score = score
        self.yes = yes
        self.no = no
    }
    
    
    
    /**
 Initialize from JSON
 **/
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    required init?(map: Map) {
        
    }
    
    
    // Mappable - mapping from JSON
    func mapping(map: Map) {
        descriptionText  <- map["description"]
        name  <- map["name"]
        no  <- map["no"]
        yes  <- map["yes"]
        score  <- map["score"]
        
    }
    
    
    
    // initialize GeriatricScale from snapshot
    init(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        // assign properties
        name = snapshotValue["name"] as! String
        descriptionText = snapshotValue["description"] as! String
        score = snapshotValue["score"] as! Double
        yes = snapshotValue["yes"] as! Int
        no = snapshotValue["no"] as! Int
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "key": key,
            "description": descriptionText,
//            "guid": guid,
//            "selectedChoice": selectedChoice,
//            "answerNumber": answerNumber,
        ]
    }
    
}
