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

struct Patient {
    
    /**
     address = Cacia;
     age = 64;
     birthDate =         {
     date = 10;
     day = 3;
     hours = 11;
     minutes = 28;
     month = 11;
     seconds = 37;
     time = "-538317082445";
     timezoneOffset = 0;
     year = 52;
     };
     picture = 2130837705;
     prescriptionsIDS =         (
     PRESCRIPTION1744401363,
     PRESCRIPTION1789288363
     );
     processNumber = 4646;
     sessionsIDS =         (
     "Thu Apr 13 15:25:40 GMT+01:00 2017",
     "Thu Apr 13 15:48:25 GMT+01:00 2017"
     );
     
     
     **/
    
    enum gender {
        case male
        case female
    }
    
    let key: String
    let favorite: Bool
    let guid: String
    let name: String
//    let gender: gender
    let ref: FIRDatabaseReference?
    let processNumber: String
    
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
        
    }
    
    // convert into NSDisctionary - needed for Firebase
    func toAnyObject() -> Any {
        return [
            "name": name,
            "favorite": favorite,
            "processNumber": processNumber
        ]
    }
    
}
