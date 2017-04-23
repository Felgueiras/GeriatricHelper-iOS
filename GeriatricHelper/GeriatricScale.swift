
import Foundation
import Firebase
import FirebaseDatabase
import ObjectMapper


class GeriatricScale: NSObject, Mappable, NSCoding {
    
    
    // decode
    required convenience init(coder aDecoder: NSCoder) {
        let area = aDecoder.decodeObject(forKey: "area") as! String
        let descriptionText = aDecoder.decodeObject(forKey: "descriptionText") as! String
        let scaleName = aDecoder.decodeObject(forKey: "scaleName") as! String
        let multipleChoice = aDecoder.decodeObject(forKey: "multipleChoice") as! Bool
        let singleQuestion = aDecoder.decodeObject(forKey: "singleQuestion") as! Bool
        let shortName = aDecoder.decodeObject(forKey: "shortName") as! String
        let scoring = aDecoder.decodeObject(forKey: "scoring") as! Scoring
        let questions = aDecoder.decodeObject(forKey: "questions") as! [Question]
        self.init(area: area, multipleChoice: multipleChoice, singleQuestion: singleQuestion,
                  descriptionText: descriptionText,
                  scaleName: scaleName,
                  questions: questions,
                  shortName: shortName,
                  scoring: scoring)
    }
    
    override init(){}
    
    // encode
    func encode(with aCoder: NSCoder) {
        aCoder.encode(area, forKey: "area")
        aCoder.encode(multipleChoice, forKey: "multipleChoice")
        aCoder.encode(singleQuestion, forKey: "singleQuestion")
        aCoder.encode(descriptionText, forKey: "descriptionText")
        aCoder.encode(scaleName, forKey: "scaleName")
        aCoder.encode(shortName, forKey: "shortName")
        aCoder.encode(scoring, forKey: "scoring")
        aCoder.encode(questions, forKey: "questions")
    }
    
    init(area: String, multipleChoice: Bool?, singleQuestion: Bool, descriptionText: String,
         scaleName: String,
         questions: [Question],
         shortName: String,
         scoring: Scoring) {
        self.area = area
        self.multipleChoice = multipleChoice
        self.singleQuestion = singleQuestion
        self.descriptionText = descriptionText
        self.scaleName = scaleName
        self.questions = questions
        self.shortName = shortName
        self.scoring = scoring
    }

    

    var key: String?
    var area: String?
    var alreadyOpened: Bool?
    var multipleChoice: Bool?
    var singleQuestion: Bool?
    var completed: Bool?
    var descriptionText: String?
    var shortName: String?
    var guid: String?
    var scoring: Scoring?
    var scaleName: String?
    var sessionID: String?
    // questions
    var questions: [Question]? = []
    var type: String?
    var ref: FIRDatabaseReference?
    var answer: String?
    var result: Double?
    
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    required init?(map: Map) {
        
    }
    
    
    // Mappable - mapping from JSON
    func mapping(map: Map) {
        area         <- map["area"]
        descriptionText  <- map["description"]
        multipleChoice  <- map["multipleChoice"]
        scaleName  <- map["scaleName"]
        shortName  <- map["shortName"]
        scoring  <- map["scoring"]
        // get questions
        questions  <- map["questions"]
        singleQuestion  <- map["singleQuestion"]
        answer  <- map["answer"]
        result  <- map["result"]
    }

    

    
    
    // initialize GeriatricScale from snapshot
    init(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        // assign properties
        area = snapshotValue["area"] as? String
        alreadyOpened = snapshotValue["alreadyOpened"] as? Bool
        completed = snapshotValue["completed"] as? Bool
        descriptionText = snapshotValue["description"] as? String
        guid = snapshotValue["guid"] as? String
        scaleName = snapshotValue["scaleName"] as? String
        sessionID = snapshotValue["sessionID"] as? String
        type = snapshotValue["type"] as? String
        scoring = snapshotValue["scoring"] as? Scoring
        singleQuestion = snapshotValue["singleQuestion"] as? Bool
        answer = snapshotValue["answer"] as? String
        result = snapshotValue["result"] as? Double
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "area": area,
            "key": key,
            "alreadyOpened": alreadyOpened,
            "completed": completed,
            "description": descriptionText,
            "guid": guid,
            "scaleName": scaleName,
            "sessionID": sessionID,
            "type": type
        ]
    }
    
}
