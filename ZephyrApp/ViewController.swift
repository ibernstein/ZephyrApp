//
//  ViewController.swift
//  ZephyrApp
//
//  Created by Hannah Mehrle on 11/9/16.
//  Copyright © 2016 Hannah Mehrle. All rights reserved.
//

import UIKit
import Firebase
//import FBSDKCoreKit
import FBSDKLoginKit


class ViewController: UIViewController, FBSDKLoginButtonDelegate{

    var loggedIn = false
    var isNewUser = true
    var user = User()
    var userId = String()
    var email = String()
    var firstName = String()
    var lastName = String()
    
    var ref = FIRDatabase.database().reference()
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email", "public_profile"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x:16, y:view.frame.height/2, width: view.frame.width-32, height:50)
        loginButton.delegate = self
        DispatchQueue.main.async(execute: {
            self.fetchProfile()
            self.addNewUserToDatabase()
        })
        //fetchProfile()
        //sleep(12)
//        if FBSDKAccessToken.current() != nil {
//            let userRef = ref.child("Users").child("\(userId)")
//            print("view contorller:  \(userId)")
//            userRef.observeSingleEvent(of: .value, with: { snapshot in
//                self.user = User(snapshot: snapshot)
//            })
//            //DispatchQueue.main.async(execute: {
//             //   self.performSegue(withIdentifier: "loginSegue", sender: nil )
//            //})
//        }
    }
    
    func fetchProfile(){
        let parameters = ["fields": "email, first_name, last_name, id"]
       
        print("Before requst")
        
       FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, result, err) in
             print("Top of graph request")
            if err != nil {
                print("Failed to start graph request:", err!)
                return
            }
            else{
                do{
                    print("Middle of graph request")
                    let userData = result as? NSDictionary
                    self.userId = userData?["id"] as! String
                    self.email = userData?["email"] as! String
                    self.firstName = userData?["first_name"] as! String
                    self.lastName = userData?["last_name"] as! String
                    print("In Graph Request: \(self.userId)")
                }
            }
        })
        print("Post Graph Request: \(userId)")
    }
    
    
    func addNewUserToDatabase(){
        
        let usersRef = ref.child("Users")
        
        usersRef.observeSingleEvent(of: .value, with: { snapshot in
            for user in snapshot.children {
                let tempUser = User(snapshot: user as! FIRDataSnapshot)
                if tempUser.userId == self.userId {
                    self.isNewUser = false
                    self.user = User(snapshot: user as! FIRDataSnapshot)
                } //if it finishes with isNewUser = true we know the user isn't in the database yet
            }
            if self.isNewUser {
                let userJobs: [Job] = []
                //segue to modal nav options for isEditor etc
                self.user = User(userId: self.userId, firstName: self.firstName, lastName: self.lastName, email: self.email, isDroneOperator: false, isEditor: false, isPropertyManager: false, userJobs: userJobs)
                self.performSegue(withIdentifier: "userInfo", sender: nil)
            } else {
                print("User already registered.")
            }
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "userInfo"){
            let info = segue.destination as! UserRegistration
            info.user = self.user
        }
        if(segue.identifier == "loginSegue"){
            print("View Controller's User ID: \(self.user.userId)")
            let tab = segue.destination as! UITabBarController
            let nav = tab.viewControllers?[0] as! UINavigationController
            let info = nav.viewControllers[0] as! AvailableJobsViewController
            print("Available User from info: \(info.user.userId)")
            info.user = self.user
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        else {
//            DispatchQueue.main.async(execute: {
//                self.fetchProfile()
//            })
            //addNewUserToDatabase()
            print("Successfully logged in")
            loggedIn = true
            self.performSegue(withIdentifier: "loginSegue", sender: nil )
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

