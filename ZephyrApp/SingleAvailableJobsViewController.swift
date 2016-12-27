//
//  SingleAvailableJobsViewController.swift
//  ZephyrApp
//
//  Created by Tony Bumatay, Hannah Mehrle, and Ian Bernstein on 11/16/16.
//  Copyright © 2016 Tony Bumatay. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SingleAvailableJobsViewController: UIViewController{
   
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
        nameLabel.text = "Job Status: \(job.jobStatus)" //actually displays job Status, not name
        let url = URL(string: job.imageURL)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.jobImage.image = UIImage(data: data!)
            }
        }
    }
    
    @IBAction func acceptJobButtonClicked(_ sender: UIButton) {
        //add selected Job to user's MyJobs
        let jobAcceptRef = self.ref.child("Jobs").child("\(self.job.key)")
        if(self.user.isDroneOperator){
            jobAcceptRef.child("DroneOperator").setValue(self.user.userId)
            jobAcceptRef.child("JobStatus").setValue("Drone Aquired")
            job.droneOperator = self.user.userId
            job.jobStatus = "Drone Aquired"
            let userJobRef = self.ref.child("Users").child("\(self.user.userId)").child("Jobs").child("\(self.job.key)")
            userJobRef.setValue(job.toAnyObject())
            self.performSegue(withIdentifier: "acceptingJobSegue", sender: nil)
        }
        else if(self.user.isEditor){
            jobAcceptRef.child("VideoEditor").setValue(self.user.userId)
            jobAcceptRef.child("JobStatus").setValue("Editor Aquired")
            job.videoEditor = self.user.userId
            job.jobStatus = "Editor Aquired"
            let userJobRef = self.ref.child("Users").child("\(self.user.userId)").child("Jobs").child("\(self.job.key)")
            userJobRef.setValue(job.toAnyObject())
            self.performSegue(withIdentifier: "acceptingJobSegue", sender: nil)
        }
    }
    
    //Prepare segue back to AvailableJobsVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "acceptingJobSegue"){
            let tab = segue.destination as! UITabBarController
            let nav = tab.viewControllers?[0] as! UINavigationController
            let info = nav.viewControllers[0] as! AvailableJobsViewController
            info.user = self.user
        }
    }
}
