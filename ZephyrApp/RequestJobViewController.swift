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
    
    func getRandomHouseImageURL() -> String {
        let houseImageURLs: [String] = ["http://p.rdcpix.com/v03/l1fa99e44-m0xd-w1020_h770_q80.jpg", "http://ap.rdcpix.com/264218382/c80f65112de01d0d92f90820a142b380l-m0xd-w640_h480_q80.jpg", "https://s-media-cache-ak0.pinimg.com/originals/bf/e2/5b/bfe25bcfb3e0136373dfb5dac55d8567.jpg", "http://ap.rdcpix.com/1497074664/f949b0bb676a540d079e8a68b79edc95l-m0xd-w640_h480_q80.jpg", "http://p.rdcpix.com/v03/lb0e5cc44-m0xd-w1020_h770_q80.jpg", "https://nextstl.com/wp-content/uploads/12739334805_0ec55c456c_o.jpg", "http://p.rdcpix.com/v04/l3fdd4f45-m0xd-w640_h480_q80.jpg", "https://8a395db01df29f9e7734-495423e69c978983374849b9c24303fc.ssl.cf5.rackcdn.com/16040450-residential-jl5cwb-l.jpg", "http://ap.rdcpix.com/1499641782/0851d1521d331d1de9835d6535995f39l-m0xd-w640_h480_q80.jpg", "http://robbpartners.com/wp-content/uploads/2013/11/511-W-polo-Clayton.jpg", "https://upload.wikimedia.org/wikipedia/commons/7/76/Whittemore_House_Club_Clayton_MO.jpg", "http://www.jimbergteam.com/images/featured/1950247759.JPG", "http://www.claytonhistorysociety.org/imageshanleyhouse/hanleyhouse.jpg", "http://media.point2.com/p2a/themeresource/9393/bd28/8797/05eeda72b204c85bdce2/Original.jpg", "http://media.theweek.com/img/generic/HH1101_MO.jpg", "http://photos.zillowstatic.com/p_e/ISivvsxbi4os5g0000000000.jpg", "http://photos.zillowstatic.com/p_e/ISq9oq0kzi0o040000000000.jpg" ] //17 image URLs
        let numURLs = houseImageURLs.count
        let randomNum = Int(arc4random_uniform(UInt32(numURLs)))
        let chosenURL = houseImageURLs[randomNum]
        return chosenURL
    }
    
    @IBAction func requestJobClicked(_ sender: UIButton) {
        let calculatedPrice = 400.00 //Double(calculatedPriceLabel.text!)
        let squareFt = Double(squareFtText.text!)
        
        let alert = UIAlertController(title: "Confirm Job Price", message: "$\(calculatedPrice)", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default){ action in
            
            let job = Job(city: self.cityText.text!, date: self.dateText.text!, indoor: self.indoorSwitch.isOn, outdoor: self.outdoorSwitch.isOn, jobStatus:"NeedsDrone", price: calculatedPrice, squareFt: squareFt!, state: self.stateText.text!, streetAddress: self.streetAddressText.text!, time: self.timeText.text!, zipCode: self.zipCodeText.text!, imageURL: self.getRandomHouseImageURL())
            
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
