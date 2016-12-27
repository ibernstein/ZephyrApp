//
//  Job.swift
//  ZephyrApp
//
//  Created by Tony Bumatay, Hannah Mehrle, and Ian Bernstein on 11/30/16.
//  Copyright © 2016 Tony Bumatay. All rights reserved.//

import Foundation
import UIKit
import Firebase

struct Job {
    let key: String
    let city: String
    let date: String
    let indoor: Bool
    let outdoor: Bool
    var jobStatus: String
    let price: Double
    let squareFt: Double
    let state: String
    let streetAddress: String
    let time: String
    let zipCode: String
    let imageURL: String
    var droneOperator: String
    var propertyManager: String
    var videoEditor: String
    let ref: FIRDatabaseReference?
    
    //initialize generic null Job
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
        self.imageURL = ""
        self.droneOperator = ""
        self.propertyManager = ""
        self.videoEditor = ""
        self.ref = nil

    }
    
    //initialize Job object with explicit values
    init(city: String, date: String, indoor: Bool, outdoor: Bool, jobStatus: String, price: Double, squareFt: Double, state: String, streetAddress: String, time: String, zipCode: String, imageURL: String, droneOperator: String, propertyManager: String, videoEditor: String, key: String = ""){
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
        self.imageURL = imageURL
        self.droneOperator = droneOperator
        self.propertyManager = propertyManager
        self.videoEditor = videoEditor
        self.ref = nil
    }
    
    //initialize Job object with Firebase snapshot
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String:AnyObject]
        city = (snapshotValue["City"] as! String)
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
        imageURL = snapshotValue["ImageURL"] as! String
        droneOperator = snapshotValue["DroneOperator"] as! String
        propertyManager = snapshotValue["PropertyManager"] as! String
        videoEditor = snapshotValue["VideoEditor"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "City": city,
            "Date": date,
            "Indoor": indoor,
            "Outdoor": outdoor,
            "JobStatus": jobStatus,
            "Price": price,
            "SquareFT": squareFt,
            "State": state,
            "StreetAddress": streetAddress,
            "Time": time,
            "ZipCode": zipCode,
            "ImageURL": imageURL,
            "DroneOperator": droneOperator,
            "PropertyManager": propertyManager,
            "VideoEditor": videoEditor
        ]
    }
}
