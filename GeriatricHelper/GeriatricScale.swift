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
    

struct GeriatricScale {
    
    let key: String
    let area: String
    let alreadyOpened: Bool
    let completed: Bool
    let description: String
    let guid: String
    let scaleName: String
    let sessionID: String
    let type: String
    let ref: FIRDatabaseReference?

    
    
    // initialize GeriatricScale from snapshot
    init(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        // assign properties
        area = snapshotValue["area"] as! String
        alreadyOpened = snapshotValue["alreadyOpened"] as! Bool
        completed = snapshotValue["completed"] as! Bool
        description = snapshotValue["description"] as! String
        guid = snapshotValue["guid"] as! String
        scaleName = snapshotValue["scaleName"] as! String
        sessionID = snapshotValue["sessionID"] as! String
        type = snapshotValue["type"] as! String
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "area": area,
            "key": key,
            "alreadyOpened": alreadyOpened,
            "completed": completed,
            "description": description,
            "guid": guid,
            "scaleName": scaleName,
            "sessionID": sessionID,
            "type": type
        ]
    }
    
}
