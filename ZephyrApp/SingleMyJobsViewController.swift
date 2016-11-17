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

    @IBOutlet weak var chosenName: UILabel!
    
    var name = String()
    
    override func viewDidLoad() {
        chosenName.text = name
    }
}
