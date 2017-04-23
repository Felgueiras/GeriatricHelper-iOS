   
   import Foundation
   import Firebase
   import FirebaseDatabase
   
   class Session {
 
    
    init(){}
    
    
    var date: Int?
    var guid: String?
    var key: String?
    var patientID: String?
    var ref: FIRDatabaseReference?
    
    
    
    // initialize Patient from snapshot
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        date = snapshotValue["date"] as! Int
        ref = snapshot.ref
        guid = snapshotValue["guid"] as! String
        patientID = snapshotValue["patientID"] as! String
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "date": date,
            "key": key,
            "guid": guid,
            "patientID": patientID
        ]
    }
    
   }
