
    import Foundation
    import Firebase
    import FirebaseDatabase
    
    class Prescription {
        
        init(){}
        
        init(drug: String,
             notes: String,
             date: Date){
            self.name = drug
            self.notes = notes
            self.date = date
            
        }
        
        var key: String?
        var ref: FIRDatabaseReference?
        
        var guid: String?
        var patientID: String?
        var name: String?
        var notes: String?
        var date: Date?
        
        
        
        
        // initialize Patient from snapshot
        init(snapshot: FIRDataSnapshot) {
            key = snapshot.key
            let snapshotValue = snapshot.value as! [String: AnyObject]
            ref = snapshot.ref
            guid = snapshotValue["guid"] as! String
            patientID = snapshotValue["patientID"] as! String
            name = snapshotValue["name"] as! String
            notes = snapshotValue["notes"] as! String
            date = NSDate(timeIntervalSince1970: (snapshotValue["date"] as! Double)) as Date
        }
        
        // convert into NSDisctionary - needed for Firebase
        func toAnyObject() -> Any {
            return [
                "key": key,
                "guid": guid,
                "patientID": patientID,
                "name": name,
                "notes": notes,
                "date": date?.timeIntervalSince1970
            ]
        }
        
    }
