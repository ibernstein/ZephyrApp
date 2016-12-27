//
//  AvailableJobsViewController.swift
//  ZephyrApp
//
//  Created by Tony Bumatay, Hannah Mehrle, and Ian Bernstein on 11/16/16.
//  Copyright © 2016 Tony Bumatay. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FBSDKLoginKit

class AvailableJobsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ref = FIRDatabase.database().reference()
    var tableView: UITableView!
    var allJobs: [Job] = []
    var user = User()
    @IBOutlet weak var addJobButton: UIButton!
    
    //Sets up table view initially & creates Facebook login button
    override func viewDidLoad() {
        super.viewDidLoad()
        addJobButton.isHidden = true
        setupTableView()
        if(user.isPropertyManager){
            addJobButton.isHidden = false
        }
    }
    
    //Allows for real-time updates
    override func viewWillAppear(_ animated: Bool) {
        fetchDataForTableView()
    }
    
    //Creates table view
    func setupTableView(){
        tableView = UITableView(frame: view.frame.offsetBy(dx:0, dy: 0))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    //Create tableView based on size of allJobs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allJobs.count
    }
    
    //Explicitly set height of all tableView cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
  
    //Real time updates of allJobs variable for the table
    func fetchDataForTableView(){
        allJobs.removeAll()
        let databaseRef = self.ref
        databaseRef.observe(.value, with: { snapshot in
            var availJobs: [Job] = []
            let jobsSnapshot = snapshot.childSnapshot(forPath: "Jobs")
            let userSnapshot = snapshot.childSnapshot(forPath: "Users").childSnapshot(forPath: "\(self.user.userId)")
            let tempUser = User(snapshot: userSnapshot)
            for job in jobsSnapshot.children {
                let tempJob = Job(snapshot: job as! FIRDataSnapshot)
                if tempUser.isDroneOperator {
                    if(tempJob.jobStatus == "Needs Drone") {
                        availJobs.append(tempJob)
                    }
                }
                if tempUser.isPropertyManager {
                    //Property managers have a blank AvailableJobsVC page
                }
                if tempUser.isEditor {
                    if(tempJob.jobStatus == "Needs Editor") {
                        availJobs.append(tempJob)
                    }
                }
            }
            self.allJobs = availJobs
            self.tableView.reloadData()
        })
    }

    //Populate tableView cell with Job data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = "\(allJobs[indexPath.row].city), \(allJobs[indexPath.row].state) \(allJobs[indexPath.row].zipCode)"
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.detailTextLabel!.text = "\(allJobs[indexPath.row].date) \(allJobs[indexPath.row].time)\n Job Status: \(allJobs[indexPath.row].jobStatus)"
        
        //Start load image to cell
        let url = URL(string: allJobs[indexPath.row].imageURL)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catcht
        let tempImage = UIImage(data: data!)
        let size = CGSize(width: 130, height: 90)
        let rect = CGRect(x: 0, y: 0, width: CGFloat(size.width), height: CGFloat(size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        tempImage?.draw(in: rect)
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //End load image to cell
        
        return cell
    }
    
    //When cell is touched, perform segue to SingleAvailableJobsVC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SingleAvailView", sender: indexPath)
    }
    
    //Triggering segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SingleAvailView"){
            let info = segue.destination as! SingleAvailableJobsViewController
            let tempRow = (sender as AnyObject).row
            info.job = allJobs[tempRow!]
            info.user = self.user
        }
        if(segue.identifier == "RequestJobAvailSegue"){
            let info = segue.destination as! RequestJobViewController
            info.user = self.user
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
