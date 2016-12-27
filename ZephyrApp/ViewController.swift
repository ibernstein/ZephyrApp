//
//  ViewController.swift
//  ZephyrApp
//
//  Created by Tony Bumatay, Hannah Mehrle, and Ian Bernstein on 11/9/16.
//  Copyright © 2016 Tony Bumatay. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit


class ViewController: UIViewController, FBSDKLoginButtonDelegate{

    var user = User()
    var loggedIn = false
    var isNewUser = true
    
    
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
        if FBSDKAccessToken.current() != nil{
            fetchProfile()
            sleep(3)
            fetchUserDatabaseInfo()
        }
    }
    
    //fetch current user's data from using FBSDK graph request
    func fetchProfile(){
        let parameters = ["fields": "email, first_name, last_name, id"]

        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, result, err) in
            if err != nil {
                print("Failed to start graph request: ", err!)
                return
            }
            else{
                do{
                    let userData = result as? NSDictionary
                    self.user.userId = userData?["id"] as! String
                    self.user.email = userData?["email"] as! String
                    self.user.firstName = userData?["first_name"] as! String
                    self.user.lastName = userData?["last_name"] as! String
                }
            }
        })
    }
    
    //Compare current user data to previously registered users --> segue and pass data (new vs. returning user)
    func fetchUserDatabaseInfo(){
        let usersRef = ref.child("Users") //Firebase reference to Users Branch
        usersRef.observeSingleEvent(of: .value, with: { snapshot in
            for user in snapshot.children {
                let tempUser = User(snapshot: user as! FIRDataSnapshot)
                if tempUser.userId == self.user.userId { //Found user match in Database
                    self.isNewUser = false
                    self.user = User(snapshot: user as! FIRDataSnapshot)
                    break
                } //if isNewUser = true we know the user isn't in the database yet
            }
            if self.isNewUser { //New user --> registration
                let userJobs: [Job] = []
                self.user = User(userId: self.user.userId, firstName: self.user.firstName, lastName: self.user.lastName, email: self.user.email, isDroneOperator: false, isEditor: false, isPropertyManager: false, userJobs: userJobs)
                self.performSegue(withIdentifier: "userInfo", sender: nil)
            } else { //Existing user --> home page (Available Jobs tab)
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        })
    }
    
    //Login
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        else {
            fetchProfile()
            sleep(3)
            fetchUserDatabaseInfo()
            print("Successfully logged in!")
        }
    }
    
    //Segue to approproate next page: User registration or Available Jobs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "userInfo"){
            let info = segue.destination as! UserRegistration
            info.user = self.user
        }
        if(segue.identifier == "loginSegue"){
            let tab = segue.destination as! UITabBarController
            let nav = tab.viewControllers?[0] as! UINavigationController
            let info = nav.viewControllers[0] as! AvailableJobsViewController
            info.user = self.user
        }
    }
    
    //Logout
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

