//
//  User.swift
//  ZephyrApp
//
//  Created by Tony Bumatay on 12/3/16.
//  Copyright © 2016 Hannah Mehrle. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct User {
    var key: String
    var userId: String
    var firstName: String
    var lastName: String
    var email: String
    var isDroneOperator: Bool
    var isEditor: Bool
    var isPropertyManager: Bool
    var userJobs: [Job]
    var ref: FIRDatabaseReference?
    
    init(){
        self.key = ""
        self.userId = ""
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.isDroneOperator = false
        self.isEditor = false
        self.isPropertyManager = false
        self.userJobs = []
        self.ref = nil
    }
    
    init(userId: String, firstName: String, lastName: String, email: String, isDroneOperator: Bool, isEditor: Bool, isPropertyManager: Bool, userJobs: [Job], key: String = ""){
        self.key = key
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.isDroneOperator = isDroneOperator
        self.isEditor = isEditor
        self.isPropertyManager = isPropertyManager
        self.userJobs = userJobs
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String:AnyObject]
        userId = (snapshotValue["UserID"] as! String)
        firstName = snapshotValue["FirstName"] as! String
        lastName = snapshotValue["LastName"] as! String
        email = snapshotValue["Email"] as! String
        isDroneOperator = snapshotValue["IsDroneOperator"] as! Bool
        isEditor = snapshotValue["IsEditor"] as! Bool
        isPropertyManager = snapshotValue["IsPropertyManager"] as! Bool
        if snapshotValue["Jobs"] != nil {
            userJobs = []
            let snapshotJobs = snapshot.childSnapshot(forPath: "Jobs")
            for job in snapshotJobs.children {
                userJobs.append(Job(snapshot: (job as! FIRDataSnapshot)))
            }
        }else {
            userJobs = []
        }
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "UserID": userId,
            "FirstName": firstName,
            "LastName": lastName,
            "Email": email,
            "IsDroneOperator": isDroneOperator,
            "IsEditor": isEditor,
            "IsPropertyManager": isPropertyManager,
            "Jobs": userJobs,
        ]
    }
}
