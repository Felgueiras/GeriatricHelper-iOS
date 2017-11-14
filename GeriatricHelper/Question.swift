import Foundation
import Firebase
import FirebaseDatabase
import ObjectMapper


class Question: NSObject, Mappable, NSCoding {
    
    // reference
    var ref: FIRDatabaseReference?
    // key
    var key: String?
    // other attributes
    var answerNumber: Int?
    var answered: Bool?
    var onlyForWomen: Bool?
    //    let choicesIDs: Bool
    var descriptionText: String?
    var guid: String?
    var selectedChoice: String?
    // choices for this questions
    var choices: [Choice]? = []
    // scale which this Question belong to
    var scale: GeriatricScale?
    var rightWrong: Bool?
    var scaleID: String?
    var yesOrNo: Bool?
    var selectedYesNo: String?
    var selectedRightWrong: String?
    var image: String?
    
    override init(){}
    
    
    
    // decode
    required convenience init(coder aDecoder: NSCoder) {
//        let answerNumber = aDecoder.decodeObject(forKey: "answerNumber") as! Int
        let choices = aDecoder.decodeObject(forKey: "choices") as! [Choice]
        let descriptionText = aDecoder.decodeObject(forKey: "description") as! String
        let image = aDecoder.decodeObject(forKey: "image") as? String
        let rightWrong = aDecoder.decodeObject(forKey: "rightWrong") as! Bool?
        let onlyForWomen = aDecoder.decodeObject(forKey: "onlyForWomen") as! Bool?
        let yesOrNo = aDecoder.decodeObject(forKey: "yesOrNo") as! Bool?
        self.init(choices: choices,
                  descriptionText: descriptionText,
                  rightWrong: rightWrong,
                  yesOrNo: yesOrNo,
                  onlyForWomen: onlyForWomen,
                  image:image
                  )
    }
    
    // encode
    func encode(with aCoder: NSCoder) {
        aCoder.encode(answerNumber, forKey: "answerNumber")
        aCoder.encode(choices, forKey: "choices")
        aCoder.encode(descriptionText, forKey: "description")
        aCoder.encode(rightWrong, forKey: "rightWrong")
        aCoder.encode(yesOrNo, forKey: "yesOrNo")
        aCoder.encode(onlyForWomen, forKey: "onlyForWomen")
        aCoder.encode(image, forKey: "image")
    }
    
    init(choices: [Choice],
         descriptionText: String,
         rightWrong: Bool?,
         yesOrNo: Bool?,
         onlyForWomen: Bool?,
         image:String?) {
//        self.answerNumber = answerNumber
        self.choices = choices
        self.descriptionText = descriptionText
        self.rightWrong = rightWrong
        self.yesOrNo = yesOrNo
        self.onlyForWomen = onlyForWomen
        self.image = image
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
        choices  <- map["choices"]
        rightWrong <- map["rightWrong"]
        yesOrNo <- map["yesOrNo"]
        onlyForWomen <- map["onlyForWomen"]
        image <- map["image"]

    }
    
    
    
    
    
    // initialize GeriatricScale from Firebase snapshot
    init(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        // assign properties
        answerNumber = snapshotValue["answerNumber"] as? Int
        answered = snapshotValue["answered"] as? Bool
        descriptionText = snapshotValue["description"] as? String
        guid = snapshotValue["guid"] as? String
        selectedChoice = snapshotValue["selectedChoice"] as? String
        image = snapshotValue["image"] as? String
        scaleID = snapshotValue["scaleID"] as? String
        onlyForWomen = snapshotValue["onlyForWomen"] as? Bool
        //        choices = snapshotValue["choices"] as! [Choice]
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "key": key,
            "description": descriptionText,
            "guid": guid,
            "selectedChoice": selectedChoice,
            "answerNumber": answerNumber,
            "selectedYesNo": selectedYesNo,
            "scaleID": scaleID,
            "answered": answered,
            "onlyForWomen": onlyForWomen,
            "image": image
        ]
    }
    
}
