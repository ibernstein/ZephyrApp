//
//  UserRegistration.swift
//  ZephyrApp
//
//  Created by Tony Bumatay on 12/3/16.
//  Copyright © 2016 Hannah Mehrle. All rights reserved.
//
import Foundation
import UIKit
import Firebase
//import FBSDKCoreKit
import FBSDKLoginKit



class UserRegistration: UIViewController{

    var user = User()
    
    @IBOutlet weak var isDroneOperator: UISwitch!
    @IBOutlet weak var isPropertyManager: UISwitch!
    @IBOutlet weak var isVideoEditor: UISwitch!
    
    @IBAction func registerUserType(_ sender: Any) {
        print("first")
        print("\(self.user.userId)")
        let newUsersRef = FIRDatabase.database().reference().child("Users").child(self.user.userId)
        newUsersRef.setValue(self.user.toAnyObject())
        self.performSegue(withIdentifier: "loginFromRegSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "loginFromRegSegue"){
            print("View Controller's User ID: \(self.user.userId)")
            let tab = segue.destination as! UITabBarController
            let nav = tab.viewControllers?[0] as! UINavigationController
            let info = nav.viewControllers[0] as! AvailableJobsViewController
            print("Available User from info: \(info.user.userId)")
            info.user = self.user
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isDroneOperator.isOn = true
        isPropertyManager.isOn = false
        isVideoEditor.isOn = false
        self.user.isDroneOperator = true
        self.user.isPropertyManager = false
        self.user.isEditor = false
    }
}
