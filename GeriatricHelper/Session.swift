   
   import Foundation
   import Firebase
   import FirebaseDatabase
   
   class Session {
 
    
    enum sessionType {
        case publicSession
        case privateSession
    }
    
    init(){}
    
    
    var date: Date?
    var guid: String?
    var key: String?
    var patientID: String?
    var ref: FIRDatabaseReference?
    var type: sessionType?
    
    var scales: [GeriatricScale]? = []
    var scalesIDS: [String] = []
    
    
    
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
