    /*
     * Copyright (c) 2015 Razeware LLC
     *
     * Permission is hereby granted, free of charge, to any person obtaining a copy
     * of this software and associated documentation files (the "Software"), to deal
     * in the Software without restriction, including without limitation the rights
     * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
     * copies of the Software, and to permit persons to whom the Software is
     * furnished to do so, subject to the following conditions:
     *
     * The above copyright notice and this permission notice shall be included in
     * all copies or substantial portions of the Software.
     *
     * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
     * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
     * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
     * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
     * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
     * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
     * THE SOFTWARE.
     */
    
    import Foundation
    import Firebase
    import FirebaseDatabase
    
    struct Session {
        enum gender {
            case male
            case female
        }
        
        let date: Int
        let guid: String
        let key: String
        let patientID: String
        let ref: FIRDatabaseReference?
        
        
        
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
