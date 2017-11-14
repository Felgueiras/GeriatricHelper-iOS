   
   import Foundation
   import Firebase
   import FirebaseDatabase
   
   class Session: NSObject, NSCoding {
    
    var date: Date?
    var guid: String?
    var key: String?
    var patientID: String?
    var ref: FIRDatabaseReference?
    var type: sessionType?
    
    var scales: [GeriatricScale]? = []
    var scalesIDS: [String] = []
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(guid, forKey: "guid")
        aCoder.encode(scales, forKey: "scales")
        aCoder.encode(scalesIDS, forKey: "scalesIDS")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObject(forKey: "date") as? Date
        let guid = aDecoder.decodeObject(forKey: "guid") as! String
        let scales : [GeriatricScale] = aDecoder.decodeObject(forKey: "scales") as! [GeriatricScale]
        self.init(date: date, guid: guid, scales: scales)
    }
    
    
    
    enum sessionType {
        case publicSession
        case privateSession
    }
    
    init(date: Date?, guid: String, scales: [GeriatricScale]){
        self.date = date
        self.guid = guid
        self.scales = scales
    }
    
    override init(){
        
    }
    
    
    
    
    
    
    // initialize Session from snapshot
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        date = NSDate(timeIntervalSince1970: (snapshotValue["date"] as! Double)) as Date
        ref = snapshot.ref
        guid = snapshotValue["guid"] as! String
        patientID = snapshotValue["patientID"] as! String
        if snapshotValue["scalesIDS"] == nil{
            scalesIDS = []
        }
        else
        {
            scalesIDS = snapshotValue["scalesIDS"] as! [String]
            
        }
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "date": date?.timeIntervalSince1970,
            "key": key,
            "guid": guid,
            "patientID": patientID,
            "scalesIDS": scalesIDS,
        ]
    }
    
    // add a scale to the session
    func addScaleID(scaleID:String)
    {
        scalesIDS.append(scaleID)
        FirebaseDatabaseHelper.updateSession(session: self)
    }
    
   }
   
