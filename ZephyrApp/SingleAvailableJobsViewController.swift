//
//  SingleAvailableJobsViewController.swift
//  ZephyrApp
//
//  Created by Hannah Mehrle on 11/16/16.
//  Copyright © 2016 Hannah Mehrle. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SingleAvailableJobsViewController: UIViewController{
   
    var ref = FIRDatabase.database().reference()
    
    var job = Job()
    
    //FIXME Outlets not linked yet
    @IBOutlet weak var outdoorLabel: UILabel!
    @IBOutlet weak var indoorLabel: UILabel!
    @IBOutlet weak var squareFtLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobImage: UIImageView!
   
    override func viewDidLoad() {
        if(job.outdoor){outdoorLabel.text = "Yes"}
        else{outdoorLabel.text = "No"}
        if(job.indoor){indoorLabel.text = "Yes"}
        else{indoorLabel.text = "No"}
        squareFtLabel.text = "\(job.squareFt) ft^2"
        zipCodeLabel.text = job.zipCode
        dateLabel.text = job.date
        timeLabel.text = job.time
        priceLabel.text = "$\(job.price)"
        
        
    }
    
    @IBAction func acceptJobButtonClicked(_ sender: UIButton) {
        //add to user's jobs
        let usersRef = self.ref.child("Users")
        //Compare current UserID to all UserIDs
        usersRef.observeSingleEvent(of: ., with: {(
            
        })
        
        
        let userRef =
        let jobsRef = userRef.child("Jobs")
        var jobNum = Int()
        
        //add Job to users jobs array
        jobsRef.observeSingleEvent(of: .value, with: {(snapshot: FIRDataSnapshot!) in
            jobNum = Int(snapshot.childrenCount)//get number of jobs
            let jobName = "Job\(jobNum)"
            //chreate a new child
            let newJobRef = jobsRef.child(jobName)
            newJobRef.setValue(job.toAnyObject())
            
        })

        
    }
}
