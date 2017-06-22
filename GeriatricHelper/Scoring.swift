
import Foundation
import Firebase
import FirebaseDatabase
import ObjectMapper


class Scoring: NSObject, Mappable, NSCoding {
    
    var key: String?
    var area: String?
    var differentMenWomen: Bool?
    var maxMen: Int?
    var maxScore: Int?
    var minMen: Int?
    var minScore: Int?
    var valuesBoth: [Grading]?
    var valuesMen: [Grading]?
    var valuesWomen: [Grading]?
    var ref: FIRDatabaseReference?
    
    
    // decode
    required convenience init(coder aDecoder: NSCoder) {
        let differentMenWomen = aDecoder.decodeObject(forKey: "differentMenWomen") as! Bool
        let maxMen = aDecoder.decodeObject(forKey: "maxMen") as! Int
        let maxScore = aDecoder.decodeObject(forKey: "maxScore") as! Int
        let minMen = aDecoder.decodeObject(forKey: "minMen") as! Int
        let minScore = aDecoder.decodeObject(forKey: "minScore") as! Int
        let valuesBoth = aDecoder.decodeObject(forKey: "valuesBoth") as? [Grading]
        let valuesMen = aDecoder.decodeObject(forKey: "valuesMen") as? [Grading]
        let valuesWomen = aDecoder.decodeObject(forKey: "valuesWomen") as? [Grading]
        self.init(differentMenWomen: differentMenWomen,
                  maxMen: maxMen,
                  maxScore: maxScore,
                  minMen: minMen,
                  minScore: minScore,
                  valuesBoth: valuesBoth,
                  valuesMen: valuesMen,
                  valuesWomen: valuesWomen)
    }
    
    // encode
    func encode(with aCoder: NSCoder) {
        aCoder.encode(differentMenWomen, forKey: "differentMenWomen")
        aCoder.encode(maxMen, forKey: "maxMen")
        aCoder.encode(maxScore, forKey: "maxScore")
        aCoder.encode(minMen, forKey: "minMen")
        aCoder.encode(minScore, forKey: "minScore")
        aCoder.encode(valuesBoth, forKey: "valuesBoth")
        aCoder.encode(valuesMen, forKey: "valuesMen")
        aCoder.encode(valuesWomen, forKey: "valuesWomen")
    }
    
    
    init(differentMenWomen: Bool,
         maxMen: Int?,
         maxScore: Int,
         minMen: Int,
         minScore: Int,
         valuesBoth: [Grading]?,
         valuesMen: [Grading]?,
         valuesWomen: [Grading]?         ) {
        
        self.differentMenWomen = differentMenWomen
        self.maxMen = maxMen
        self.minMen = minMen
        self.maxScore = maxScore
        self.minScore = minScore
        self.valuesBoth = valuesBoth
        self.valuesMen = valuesMen
        self.valuesWomen = valuesWomen
        
    }
    
    
    
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    required init?(map: Map) {
        
    }
    
    
    // Mappable - mapping from JSON
    func mapping(map: Map) {
        area         <- map["area"]
        differentMenWomen  <- map["differentMenWomen"]
        maxMen  <- map["maxMen"]
        maxScore  <- map["maxScore"]
        minMen  <- map["minMen"]
        minScore  <- map["minScore"]
        valuesBoth <- map["valuesBoth"]
        valuesMen <- map["valuesMen"]
        valuesWomen <- map["valuesWomen"]
    }

    

    
    
    // initialize GeriatricScale from snapshot
    init(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        // assign properties
        area = snapshotValue["area"] as? String
//        alreadyOpened = snapshotValue["alreadyOpened"] as? Bool
//        completed = snapshotValue["completed"] as? Bool
//        description = snapshotValue["description"] as? String
//        guid = snapshotValue["guid"] as? String
//        scaleName = snapshotValue["scaleName"] as? String
//        sessionID = snapshotValue["sessionID"] as? String
//        type = snapshotValue["type"] as? String
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "area": area,
//            "key": key,
//            "alreadyOpened": alreadyOpened,
//            "completed": completed,
//            "description": description,
//            "guid": guid,
//            "scaleName": scaleName,
//            "sessionID": sessionID,
//            "type": type
        ]
    }
   
    
    func getGrading(testResult: Double, gender: String) -> Grading? {
        var match: Grading? = nil
        
        var toConsider: [Grading]? = []
        if gender == "male"{
            toConsider = valuesMen
        }
            
        else if gender == "female"
        {
            toConsider = valuesWomen
        }
            
        else
        {
            toConsider = valuesBoth
        }
        
        for grading in toConsider! {
            // check the grading for the result we have
            if grading.containsScore(testResult: testResult) {
                match = grading
                break
            }
        }
        return match;
    }
    
}
