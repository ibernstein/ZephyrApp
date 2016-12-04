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
    
    //Every time something changes, it calls fetchDataForTableView
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
    
  
    //Auto Reupdates information in the allJobs variable for the table
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
                    //Create a message for user
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
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.detailTextLabel!.text = "\(allJobs[indexPath.row].date) \(allJobs[indexPath.row].time)\n Job Status: \(allJobs[indexPath.row].jobStatus)"
        
        //START image stuff
        let url = URL(string: allJobs[indexPath.row].imageURL)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catcht
        let tempImage = UIImage(data: data!)
        let size = CGSize(width: 130, height: 90)
        let rect = CGRect(x: 0, y: 0, width: CGFloat(size.width), height: CGFloat(size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        tempImage?.draw(in: rect)
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //END image stuff
        
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
