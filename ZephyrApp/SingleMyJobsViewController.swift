//
//  SingleMyJobsViewController.swift
//  ZephyrApp
//
//  Created by Hannah Mehrle on 11/17/16.
//  Copyright © 2016 Hannah Mehrle. All rights reserved.
//

import Foundation
import UIKit

class SingleMyJobsViewController: UIViewController {

    var job = Job()
    
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
    
    
}
