//
//  SingleAvailableJobsViewController.swift
//  ZephyrApp
//
//  Created by Hannah Mehrle on 11/16/16.
//  Copyright © 2016 Hannah Mehrle. All rights reserved.
//

import Foundation
import UIKit

class SingleAvailableJobsViewController: UIViewController {
    
    @IBOutlet weak var chosenName: UILabel!
    
    var name = String()
    
    override func viewDidLoad() {
        chosenName.text = name
    }
}
