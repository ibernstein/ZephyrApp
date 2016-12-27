//
//  UserRegistration.swift
//  ZephyrApp
//
//  Created by Tony Bumatay, Hannah Mehrle, and Ian Bernstein on 12/3/16.
//  Copyright © 2016 Tony Bumatay. All rights reserved.//
import Foundation
import UIKit
import Firebase
import FBSDKLoginKit



class UserRegistration: UIViewController{

    var user = User()
    
    @IBOutlet weak var isDroneOperator: UISwitch!
    @IBOutlet weak var isPropertyManager: UISwitch!
    @IBOutlet weak var isVideoEditor: UISwitch!
    
    //Set initial values. Users are only allowed to select one of the three options (Drone Operator, Property Manager, or Video Editor)
    override func viewDidLoad() {
        super.viewDidLoad()
        isDroneOperator.isOn = true
        isPropertyManager.isOn = false
        isVideoEditor.isOn = false
        self.user.isDroneOperator = true
        self.user.isPropertyManager = false
        self.user.isEditor = false
    }
    
    @IBAction func droneAction(_ sender: Any) {
        isPropertyManager.isOn = false
        isVideoEditor.isOn = false
        isDroneOperator.isOn = true
        self.user.isDroneOperator = true
        self.user.isPropertyManager = false
        self.user.isEditor = false
    }
    @IBAction func videoAction(_ sender: Any) {
        isDroneOperator.isOn = false
        isPropertyManager.isOn = false
        isVideoEditor.isOn = true
        self.user.isDroneOperator = false
        self.user.isPropertyManager = false
        self.user.isEditor = true
    }
    
    @IBAction func propertyManager(_ sender: Any) {
        isDroneOperator.isOn = false
        isVideoEditor.isOn = false
        isPropertyManager.isOn = true
        self.user.isDroneOperator = false
        self.user.isPropertyManager = true
        self.user.isEditor = false
    }
    
    @IBAction func registerUserType(_ sender: Any) {
        let newUsersRef = FIRDatabase.database().reference().child("Users").child(self.user.userId)
        newUsersRef.setValue(self.user.toAnyObject())
        self.performSegue(withIdentifier: "loginFromRegSegue", sender: nil)
    }
    
    //Segue to Available Jobs View Controller and pass user's data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "loginFromRegSegue"){
            let tab = segue.destination as! UITabBarController
            let nav = tab.viewControllers?[0] as! UINavigationController
            let info = nav.viewControllers[0] as! AvailableJobsViewController
            info.user = self.user
        }
    }
    
}
