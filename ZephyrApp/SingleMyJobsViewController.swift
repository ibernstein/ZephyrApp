//
//  SingleMyJobsViewController.swift
//  ZephyrApp
//
//  Created by Tony Bumatay, Hannah Mehrle, and Ian Bernstein on 11/17/16.
//  Copyright © 2016 Tony Bumatay. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SingleMyJobsViewController: UIViewController {

    var ref = FIRDatabase.database().reference()
    var job = Job()
    var user = User()
    
    @IBOutlet weak var outdoorLabel: UILabel!
    @IBOutlet weak var indoorLabel: UILabel!
    @IBOutlet weak var squareFtLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var giveUpJobButton: UIButton!
    
    
   
    
    override func viewDidLoad() {
        completeButton.isHidden = true
        giveUpJobButton.isHidden = true
        //User is a PropertyManager
        if(self.user.isPropertyManager){
            if self.job.jobStatus == "Needs Drone" && self.user.userId == self.job.propertyManager{
                giveUpJobButton.isHidden = false
            }
        }
        //User is a DroneOperator
        if(self.user.isDroneOperator){
            if self.job.jobStatus == "Drone Aquired" && self.user.userId == self.job.droneOperator {
                completeButton.isHidden = false
                giveUpJobButton.isHidden = false
            }
        }
        //User is an Editor
        if(self.user.isEditor){
            if self.job.jobStatus == "Editor Aquired" && self.user.userId == self.job.videoEditor{
                completeButton.isHidden = false
                giveUpJobButton.isHidden = false
            }
        }
        
        if(job.outdoor){outdoorLabel.text = "Yes"}
        else{outdoorLabel.text = "No"}
        if(job.indoor){indoorLabel.text = "Yes"}
        else{indoorLabel.text = "No"}
        squareFtLabel.text = "\(job.squareFt) ft^2"
        zipCodeLabel.text = job.zipCode
        dateLabel.text = job.date
        timeLabel.text = job.time
        priceLabel.text = "$\(job.price)"
        addressLabel.text = job.streetAddress
        nameLabel.text = "Job Status: \(job.jobStatus)" //actually displays job Status, not name
        let url = URL(string: job.imageURL)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.jobImage.image = UIImage(data: data!)
            }
        }
        
    }
    
    //The job's status should be updated and values for associated users should be updated accordingly (i.e. drone operator completes job: status goes from "Drone Acquired" --> "Needs Editor")
    @IBAction func completeJob(_ sender: Any) {
        let jobCompleteRef = self.ref.child("Jobs").child("\(self.job.key)")
        //User is a Drone Operator
        if(self.user.isDroneOperator){
            jobCompleteRef.child("JobStatus").setValue("Needs Editor")
            job.jobStatus = "Needs Editor"
            let userJobRef = self.ref.child("Users").child("\(self.user.userId)").child("Jobs").child("\(self.job.key)")
            userJobRef.setValue(job.toAnyObject())
            
            let propertyManagerID = job.propertyManager
            let userRef = ref.child("Users").child(propertyManagerID)
            userRef.child("Jobs").child("\(self.job.key)").child("JobStatus").setValue("Needs Editor")
            
        }
        //User is a Editor
        else if(self.user.isEditor){
            //Change job status in Jobs branch in Firebase
            jobCompleteRef.child("JobStatus").setValue("Completed!")
            //get User ID of propertyManager; Change job status in propertyManager's Job Branch in Firebase
            let propertyManagerID = job.propertyManager
            let propertyManagerRef = ref.child("Users").child(propertyManagerID)
            propertyManagerRef.child("Jobs").child("\(self.job.key)").child("JobStatus").setValue("Completed!")
            
            //get User ID of droneOperator; Change job status in droneOperator's Job Branch in Firebase
            let droneOperatorID = job.droneOperator
            let droneOperatorRef = ref.child("Users").child(droneOperatorID)
            droneOperatorRef.child("Jobs").child("\(self.job.key)").child("JobStatus").setValue("Completed!")
            droneOperatorRef.child("Jobs").child("\(self.job.key)").child("JobStatus").setValue("Completed!")
            job.jobStatus = "Completed!"
            let userJobRef = self.ref.child("Users").child("\(self.user.userId)").child("Jobs").child("\(self.job.key)")
            userJobRef.setValue(job.toAnyObject())
        }
    }
    
    //User gives up a job from their "MyJobs" list. The job's status should be updated and values for associated users should be updated accordingly (i.e. drone operator no longer associated with job if he gives up the job)
    @IBAction func giveUpSingleJob(_ sender: UIButton) {
        let jobCompleteRef = self.ref.child("Jobs").child("\(self.job.key)")
        //User is a Drone Operator
        if(self.user.isDroneOperator){
            jobCompleteRef.child("DroneOperator").setValue("Not Found")
            jobCompleteRef.child("JobStatus").setValue("Needs Drone")
            job.droneOperator = "Not Found"
            let userJobRef = self.ref.child("Users").child("\(self.user.userId)").child("Jobs").child("\(self.job.key)")
            userJobRef.removeValue()
        }
        //User is an Editor
        else if(self.user.isEditor){
            jobCompleteRef.child("VideoEditor").setValue("Not Found")
            jobCompleteRef.child("JobStatus").setValue("Needs Editor")
            job.droneOperator = "Not Found"
            let userJobRef = self.ref.child("Users").child("\(self.user.userId)").child("Jobs").child("\(self.job.key)")
            userJobRef.removeValue()
        }
        //User is a Property Manager
        else if(self.user.isPropertyManager){
            let userJobRef = self.ref.child("Users").child("\(self.user.userId)").child("Jobs").child("\(self.job.key)")
            userJobRef.removeValue()
            jobCompleteRef.removeValue()
        }
    }
    
    //Prepare to segue on Complete Job action or Give up Job action
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "completeJobSegue"){
            let tab = segue.destination as! UITabBarController
            let nav = tab.viewControllers?[0] as! UINavigationController
            let info = nav.viewControllers[0] as! AvailableJobsViewController
            info.user = self.user
        }
        if(segue.identifier == "GiveUpJobSegue"){
            let tab = segue.destination as! UITabBarController
            let nav = tab.viewControllers?[0] as! UINavigationController
            let info = nav.viewControllers[0] as! AvailableJobsViewController
            info.user = self.user
        }
    }
}
