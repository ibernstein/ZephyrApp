//
//  RequestJobViewController.swift
//  ZephyrApp
//
//  Created by Tony Bumatay on 12/2/16.
//  Copyright © 2016 Hannah Mehrle. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class RequestJobViewController: UIViewController, UIScrollViewDelegate {
    
    var ref = FIRDatabase.database().reference()

    
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
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//    }
//    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return scrollView.subviews.first
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView.delegate = self
        scrollView.contentSize.height = 850
        //view.addSubview(scrollView)
        
    }
    
    
    
    @IBAction func requestJobClicked(_ sender: UIButton) {
        let calculatedPrice = 400.00 //Double(calculatedPriceLabel.text!)
        let squareFt = Double(squareFtText.text!)

        
        let alert = UIAlertController(title: "Confirm Job Price", message: "$\(calculatedPrice)", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default){ action in
            
            let job = Job(city: self.cityText.text!, date: self.dateText.text!, indoor: self.indoorSwitch.isOn, outdoor: self.outdoorSwitch.isOn, jobStatus:"NeedsDrone", price: calculatedPrice, squareFt: squareFt!, state: self.stateText.text!, streetAddress: self.streetAddressText.text!, time: self.timeText.text!, zipCode: self.zipCodeText.text!)
            
            let jobsRef = self.ref.child("Jobs")
            var jobNum = Int()
            jobsRef.observeSingleEvent(of: .value, with: {(snapshot: FIRDataSnapshot!) in
                jobNum = Int(snapshot.childrenCount)
                let jobName = "Job\(jobNum)"
                //chreate a new child
                let newJobRef = jobsRef.child(jobName)
                newJobRef.setValue(job.toAnyObject())
                
            })

                      // make sure nothing is nil
            self.performSegue(withIdentifier: "JobRequested", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
}
