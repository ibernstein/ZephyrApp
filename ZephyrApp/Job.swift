//
//  Job.swift
//  ZephyrApp
//
//  Created by Tony Bumatay on 11/30/16.
//  Copyright © 2016 Hannah Mehrle. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Job {
    let key: String
    let city: String
    let date: String
    let indoor: Bool
    let outdoor: Bool
    let jobStatus: String
    let price: Double
    let squareFt: Double
    let state: String
    let streetAddress: String
    let time: String
    let zipCode: String
    let ref: FIRDatabaseReference?
    
    init(){
        self.key = ""
        self.city = ""
        self.date = ""
        self.indoor = false
        self.outdoor = false
        self.jobStatus = ""
        self.price = 0.00
        self.squareFt = 0.00
        self.state = ""
        self.streetAddress = ""
        self.time = ""
        self.zipCode = ""
        self.ref = nil

    }
    
    init(city: String, date: String, indoor: Bool, outdoor: Bool, jobStatus: String, price: Double, squareFt: Double, state: String, streetAddress: String, time: String, zipCode: String, key: String = ""){
        self.key = key
        self.city = city
        self.date = date
        self.indoor = indoor
        self.outdoor = outdoor
        self.jobStatus = jobStatus
        self.price = price
        self.squareFt = squareFt
        self.state = state
        self.streetAddress = streetAddress
        self.time = time
        self.zipCode = zipCode
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String:AnyObject]
        city = snapshotValue["City"] as! String
        date = snapshotValue["Date"] as! String
        indoor = snapshotValue["Indoor"] as! Bool
        outdoor = snapshotValue["Outdoor"] as! Bool
        jobStatus = snapshotValue["JobStatus"] as! String
        price = snapshotValue["Price"] as! Double
        squareFt = snapshotValue["SquareFT"] as! Double
        state = snapshotValue["State"] as! String
        streetAddress = snapshotValue["StreetAddress"] as! String
        time = snapshotValue["Time"] as! String
        zipCode = snapshotValue["ZipCode"] as! String
        ref = snapshot.ref
    }
    
    func toAnyOption() -> Any {
        return [
            "city": city,
            "date": date,
            "indoor": indoor,
            "outdoor": outdoor,
            "jobStatus": jobStatus,
            "price": price,
            "squareFt": squareFt,
            "state": state,
            "streetAddress": streetAddress,
            "time": time,
            "zipCode": zipCode
        ]
    }
}
