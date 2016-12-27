//
//  RequestJobViewController.swift
//  ZephyrApp
//
//  Created by Tony Bumatay, Hannah Mehrle, and Ian Bernstein on 12/2/16.
//  Copyright © 2016 Tony Bumatay. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RequestJobViewController: UIViewController, UIScrollViewDelegate {
    
    var ref = FIRDatabase.database().reference()
    var user = User()

    @IBOutlet weak var outdoorSwitch: UISwitch!
    @IBOutlet weak var indoorSwitch: UISwitch!
    @IBOutlet weak var squareFtText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var streetAddressText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var zipCodeText: UITextField!
    @IBOutlet weak var calculatedPriceLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView.delegate = self
        scrollView.contentSize.height = 850
        //view.addSubview(scrollView)
        
    }
    
    func datePickerValueChanged(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
                dateText.text = dateFormatter.string(from: sender.date)
    }
    
    func timePickerValueChanged(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        timeText.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func chooseDate(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func chooseTime(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.timePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    //Retrieve a random Stock Image
    //TODO: Allow Property Manager to upload image link
    func getRandomHouseImageURL() -> String {
        let houseImageURLs: [String] = ["http://p.rdcpix.com/v03/l1fa99e44-m0xd-w1020_h770_q80.jpg", "http://ap.rdcpix.com/264218382/c80f65112de01d0d92f90820a142b380l-m0xd-w640_h480_q80.jpg", "https://s-media-cache-ak0.pinimg.com/originals/bf/e2/5b/bfe25bcfb3e0136373dfb5dac55d8567.jpg", "http://ap.rdcpix.com/1497074664/f949b0bb676a540d079e8a68b79edc95l-m0xd-w640_h480_q80.jpg", "http://p.rdcpix.com/v03/lb0e5cc44-m0xd-w1020_h770_q80.jpg", "https://nextstl.com/wp-content/uploads/12739334805_0ec55c456c_o.jpg", "http://p.rdcpix.com/v04/l3fdd4f45-m0xd-w640_h480_q80.jpg", "https://8a395db01df29f9e7734-495423e69c978983374849b9c24303fc.ssl.cf5.rackcdn.com/16040450-residential-jl5cwb-l.jpg", "http://ap.rdcpix.com/1499641782/0851d1521d331d1de9835d6535995f39l-m0xd-w640_h480_q80.jpg", "http://robbpartners.com/wp-content/uploads/2013/11/511-W-polo-Clayton.jpg", "https://upload.wikimedia.org/wikipedia/commons/7/76/Whittemore_House_Club_Clayton_MO.jpg", "http://www.jimbergteam.com/images/featured/1950247759.JPG", "http://www.claytonhistorysociety.org/imageshanleyhouse/hanleyhouse.jpg", "http://media.point2.com/p2a/themeresource/9393/bd28/8797/05eeda72b204c85bdce2/Original.jpg", "http://media.theweek.com/img/generic/HH1101_MO.jpg", "http://photos.zillowstatic.com/p_e/ISivvsxbi4os5g0000000000.jpg", "http://photos.zillowstatic.com/p_e/ISq9oq0kzi0o040000000000.jpg" ] //Stock images
        let numURLs = houseImageURLs.count
        let randomNum = Int(arc4random_uniform(UInt32(numURLs)))
        let chosenURL = houseImageURLs[randomNum]
        return chosenURL
    }
    
    //Create a new Job object based on Property Manager's request and store in Firebase
    @IBAction func requestJobClicked(_ sender: UIButton) {
        var squareFt = 0.0
        
        //valid inputs
        if Double(squareFtText.text!) != nil && Double(squareFtText.text!)! > 0.0 && Int(zipCodeText.text!) != nil && Int(zipCodeText.text!)! > 0 {
            squareFt = Double(squareFtText.text!)!
        }
            
        //invalid inputs
        else{
            let alert = UIAlertController(title: "Incorrect Information", message: "Confirm that following fields are correct\nSquare Ft: type Double\nZipcode: type Int\nLastly, make sure all fields are filled out", preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default){ action in
                return
            }
            alert.addAction(retryAction)
            present(alert, animated: true, completion: nil)
        }
        
        //valud inputs
        if streetAddressText.text!.characters.count > 0 && cityText.text!.characters.count > 0  && stateText.text!.characters.count > 0  && timeText.text!.characters.count > 0 && dateText.text!.characters.count > 0{
            let calculatedPrice = squareFt * 0.05 //TODO: determine pricing algorithm
            
            let alert = UIAlertController(title: "Confirm Job Price", message: "$\(calculatedPrice)", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .default){ action in
                //create new Job object
                let job = Job(city: self.cityText.text!, date: self.dateText.text!, indoor: self.indoorSwitch.isOn, outdoor: self.outdoorSwitch.isOn, jobStatus:"Needs Drone", price: calculatedPrice, squareFt: squareFt, state: self.stateText.text!, streetAddress: self.streetAddressText.text!, time: self.timeText.text!, zipCode: self.zipCodeText.text!, imageURL: self.getRandomHouseImageURL(), droneOperator: "Not Found", propertyManager: self.user.userId, videoEditor: "Not Found")
                
                let databaseRef = self.ref
                databaseRef.observeSingleEvent(of: .value, with: {(snapshot: FIRDataSnapshot!) in
                    let jobNum = (snapshot.childSnapshot(forPath: "Job Count Constant").value as! Int) + 1
                    let jobName = "Job \(jobNum)"
                    let newJobRef = databaseRef.child("Jobs").child(jobName)
                    newJobRef.setValue(job.toAnyObject())
                    //Add job to main Jobs branch
                    databaseRef.child("Job Count Constant").setValue(jobNum as AnyObject)
                    //Add job to respective User's Jobs sub-branch
                    databaseRef.child("Users").child(self.user.userId).child("Jobs").child(jobName).setValue(job.toAnyObject())
                    self.performSegue(withIdentifier: "jobRequested", sender: nil)
                })
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
        else{
            //Invalid Inputs
            let alert = UIAlertController(title: "Incorrect Information", message: "Confirm that all fields are filled out", preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default){ action in
                return
            }
            alert.addAction(retryAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //Prepare segue back to AvailableJobsVC; send user data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "jobRequested"){
            print("Single Avail VC to Avail VC User ID sent: \(self.user.userId)")
            let tab = segue.destination as! UITabBarController
            let nav = tab.viewControllers?[0] as! UINavigationController
            let info = nav.viewControllers[0] as! AvailableJobsViewController
            info.user = self.user
        }
    }
}
