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
    
    var ref = FIRDatabase.database().reference()
    var tableView: UITableView!
    var allJobs: [Job] = []
    
    //Sets up table view initially & creates Facebook login button
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
    }
    
    //Every time something changes, it calls fetchDataForTableView
    override func viewWillAppear(_ animated: Bool) {
        fetchDataForTableView()
    }
    
    //Facebook login in functionality
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
                self.performSegue(withIdentifier: "loginSegue", sender: nil )
            })
        }
    
    }
    
    //Creates table view
    func setupTableView(){
        tableView = UITableView(frame: view.frame.offsetBy(dx:0, dy: 0))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    //Auto Reupdates information in the allJobs variable for the table
    func fetchDataForTableView(){
        allJobs.removeAll()
        let jobsRef = ref.child("Jobs")
        jobsRef.observe(.value, with: { snapshot in
            var availJobs: [Job] = []
            for job in snapshot.children {
                let tempJob = Job(snapshot: job as! FIRDataSnapshot)
                availJobs.append(tempJob)
            }
            self.allJobs = availJobs
            self.tableView.reloadData()
        })
    }
    
    //Triggering segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SingleAvailView"){
            let info = segue.destination as! SingleAvailableJobsViewController
            let tempRow = (sender as AnyObject).row
            info.job = allJobs[tempRow!]
        }
    }
    
    //Change height of table view cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    //Create tabel view based on size of allJobs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allJobs.count
    }
    
    //Modify what shows in each table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = "\(allJobs[indexPath.row].city), \(allJobs[indexPath.row].state) \(allJobs[indexPath.row].zipCode)"
        cell.detailTextLabel!.text = "\(allJobs[indexPath.row].date) \(allJobs[indexPath.row].time)"
        return cell
    }
    
    //When cell is touched, perform segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SingleAvailView", sender: indexPath)
    }
    
    //unkown purpose?
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
