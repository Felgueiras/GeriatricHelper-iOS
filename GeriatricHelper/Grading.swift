
import Foundation
import Firebase
import FirebaseDatabase
import ObjectMapper


class Grading: NSObject, Mappable, NSCoding {
    
    
    // Firebase scpecific
    var key: String?
    var ref: FIRDatabaseReference?
    
    // fields
    var grade: String?
    var max: Int?
    var min: Int?
    var score: String?
    var descriptionText: String?
    
    
    // decode
    required convenience init(coder aDecoder: NSCoder) {
        let grade = aDecoder.decodeObject(forKey: "grade") as! String
        let max = aDecoder.decodeObject(forKey: "max") as! Int
        let min = aDecoder.decodeObject(forKey: "min") as! Int
        let score = aDecoder.decodeObject(forKey: "score") as! String
        let descriptionText:String? = aDecoder.decodeObject(forKey: "description") as? String
        self.init(grade: grade,
                  max: max,
                  min: min,
                  score: score,
                  descriptionText: descriptionText)
    }
    
    // encode
    func encode(with aCoder: NSCoder) {
        aCoder.encode(grade, forKey: "grade")
        aCoder.encode(max, forKey: "max")
        aCoder.encode(min, forKey: "min")
        aCoder.encode(score, forKey: "score")
        aCoder.encode(descriptionText, forKey: "description")
    }
    
    
    init(grade: String,
         max: Int?,
         min: Int,
         score: String,
         descriptionText: String?) {
        
        self.grade = grade
        self.max = max
        self.min = min
        self.score = score
        self.descriptionText = descriptionText
        
    }

    
    
    
    
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    required init?(map: Map) {
        
    }
    
    
    // Mappable
    func mapping(map: Map) {
        grade  <- map["grade"]
        max  <- map["max"]
        min  <- map["min"]
        score  <- map["score"]
        descriptionText  <- map["description"]
    }
    
    
    
    
    
    // initialize GeriatricScale from snapshot
    init(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        // assign properties
        grade = snapshotValue["grade"] as? String
        max = snapshotValue["max"] as? Int
        min = snapshotValue["min"] as? Int
        score = snapshotValue["score"] as? String
//        guid = snapshotValue["guid"] as? String
//        scaleName = snapshotValue["scaleName"] as? String
//        sessionID = snapshotValue["sessionID"] as? String
//        type = snapshotValue["type"] as? String
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "grade": grade
//            "area": area,
//            "key": key,
//            "alreadyOpened": alreadyOpened,
//            "completed": completed,
//            "description": description,
//            "guid": guid,
//            "scaleName": scaleName,
//            "sessionID": sessionID,
            
        ]
    }
    
    
    func containsScore(testResult: Double) -> Bool{
     
        
        var values:[String] = []
        values = (score?.characters.split(separator: ",").map(String.init))!
        
        var vals:[Double] = []


        for  s in values {
            vals.append(Double(s)!)
        }
        return vals.contains(testResult)
    }
    
}
