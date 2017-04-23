
    import Foundation
    import Firebase
    import FirebaseDatabase
    
    class Prescription {
        
        let key: String
        let ref: FIRDatabaseReference?
        
        let guid: String
        let patientID: String
        let name: String
        let notes: String
        
        
        
        
        // initialize Patient from snapshot
        init(snapshot: FIRDataSnapshot) {
            key = snapshot.key
            let snapshotValue = snapshot.value as! [String: AnyObject]
            ref = snapshot.ref
            guid = snapshotValue["guid"] as! String
            patientID = snapshotValue["patientID"] as! String
            name = snapshotValue["name"] as! String
            notes = snapshotValue["notes"] as! String
        }
        
        // convert into NSDisctionary - needed for Firebase
        func toAnyObject() -> Any {
            return [
                "key": key,
                "guid": guid,
                "patientID": patientID
            ]
        }
        
    }
