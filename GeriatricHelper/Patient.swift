
import Foundation
import Firebase
import FirebaseDatabase

class Patient: NSObject, NSCoding {
    
    init(name: String,
         guid: String,
         favorite: Bool,
         address: String) {
        self.name = name
        self.guid = guid
        self.favorite = favorite
        self.address = address
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let favorite = aDecoder.decodeObject(forKey: "favorite") as! Bool
        let guid = aDecoder.decodeObject(forKey: "guid") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let address = aDecoder.decodeObject(forKey: "address") as! String

        self.init(name: name,
                  guid: guid,
                  favorite: favorite,
                  address: address)
    }

    
    // encode
    func encode(with aCoder: NSCoder) {
        aCoder.encode(favorite, forKey: "favorite")
        aCoder.encode(guid, forKey: "guid")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(address, forKey: "address")
    }

    
    
    enum gender {
        case male
        case female
    }
    
    var key: String?
    var favorite: Bool?
    var guid: String?
    var name: String?
    var address: String?
    var gender: String?
    var ref: FIRDatabaseReference?
    var processNumber: String?
    var  prescriptionsIDS: [String] = []
    
    //    init(name: String,  key: String = "") {
    //        self.key = key
    //        self.name = name
    //        self.addedByUser = addedByUser
    //        self.completed = completed
    //        self.ref = nil
    //    }
    
    // initialize Patient from snapshot
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        ref = snapshot.ref
        processNumber = snapshotValue["processNumber"] as! String
        favorite = snapshotValue["favorite"] as! Bool
        guid = snapshotValue["guid"] as! String
        prescriptionsIDS = snapshotValue["prescriptionsIDS"] as! [String]
        
    }
    
    override init(){
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "name": name,
            "favorite": favorite,
            "processNumber": processNumber,
            "prescriptionsIDS": prescriptionsIDS
        ]
    }
    
    func addPrescription(prescriptionID: String) {
        prescriptionsIDS.append(prescriptionID)
        // update patient
        PatientsManagement.updatePatient(patient: self)
    }
    
}
