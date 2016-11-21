//
//  AvailableJobsViewController.swift
//  ZephyrApp
//
//  Created by Hannah Mehrle on 11/16/16.
//  Copyright © 2016 Hannah Mehrle. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FBSDKLoginKit

class AvailableJobsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FBSDKLoginButtonDelegate {
    
    var tableView: UITableView!
    var dummyJobs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchDataForTableView()
        self.tableView.reloadData()
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
            print("Successfully logged in")
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "loginSegue", sender: nil )})
            
            //loggedInView.result = result;
            
        
    }
    
}
    func setupTableView(){
        tableView = UITableView(frame: view.frame.offsetBy(dx:0, dy: 0))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    func fetchDataForTableView(){
        dummyJobs.removeAll()
        dummyJobs.append("Job1")
         dummyJobs.append("Job2")
         dummyJobs.append("Job3")
        dummyJobs.append("Job4")
         dummyJobs.append("Job5")
        self.tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SingleAvailView"){
            let info = segue.destination as! SingleAvailableJobsViewController
            let tempRow = (sender as AnyObject).row
            info.name = dummyJobs[tempRow!]
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyJobs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = dummyJobs[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SingleAvailView", sender: indexPath)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
