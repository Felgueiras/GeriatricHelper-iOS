import Foundation
import Firebase
import FirebaseDatabase
import ObjectMapper


class QuestionCategory: NSObject, Mappable, NSCoding {
    
    // reference
    var ref: FIRDatabaseReference?
    // key
    var key: String?
    var category: String?
    var descriptionText: String?
    var notes: String?
    var questions: [Question]? = []

    
    override init(){}
    
    init(category: String?,
         descriptionText: String?,
         questions: [Question],
         notes: String?) {
        
        self.category = category
        self.descriptionText = descriptionText
        self.questions = questions
        self.notes = notes
        
    }
    // encode
    func encode(with aCoder: NSCoder) {
        aCoder.encode(category, forKey: "category")
        aCoder.encode(descriptionText, forKey: "description")
        aCoder.encode(questions, forKey: "questions")
        aCoder.encode(notes, forKey: "notes")
    }
    
    // decode
    required convenience init(coder aDecoder: NSCoder) {
        let category:String? = aDecoder.decodeObject(forKey: "category") as? String
        let descriptionText:String? = aDecoder.decodeObject(forKey: "description") as? String
        let notes:String? = aDecoder.decodeObject(forKey: "notes") as? String
        let questions = aDecoder.decodeObject(forKey: "questions") as! [Question]

        self.init(category: category,
                  descriptionText: descriptionText,
                  questions: questions,
                  notes:notes)
    }
    
    
    
    
    /**
     Initialize from JSON.
     **/
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    required init?(map: Map) {
        
    }
    
    
    // Mappable - mapping from JSON
    func mapping(map: Map) {
        descriptionText  <- map["description"]
        category  <- map["category"]
        questions  <- map["questions"]
        notes  <- map["notes"]
    }
    
    
    
    // initialize GeriatricScale from Firebase snapshot
    init(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        // assign properties

        descriptionText = (snapshotValue["description"] as! String)

        //        choices = snapshotValue["choices"] as! [Choice]
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "key": key,
            "description": descriptionText,
            "notes": notes,
            
        ]
    }
    
}
