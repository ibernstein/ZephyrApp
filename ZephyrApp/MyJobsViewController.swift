//
//  MyJobsViewController.swift
//  ZephyrApp
//
//  Created by Tony Bumatay, Hannah Mehrle, and Ian Bernstein on 11/17/16.
//  Copyright © 2016 Tony Bumatay. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MyJobsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ref = FIRDatabase.database().reference()
    var tableView: UITableView!
    var myJobs: [Job] = []
    var user = User()
    @IBOutlet weak var addJobButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addJobButton.isHidden = true
        setupTableView()
        let firstTab = self.tabBarController?.viewControllers?[0] as! UINavigationController
        let info = firstTab.viewControllers[0] as! AvailableJobsViewController
        self.user = info.user
        
        if(user.isPropertyManager){
            addJobButton.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDataForTableView()
        self.tableView.reloadData()
    }
    
    func setupTableView(){
        tableView = UITableView(frame: view.frame.offsetBy(dx:0, dy: 0))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    //Query Firebase for all the Jobs for a given User
    func fetchDataForTableView(){
        self.myJobs.removeAll()
        let userRef = ref.child("Users").child(self.user.userId)
        userRef.observe(.value, with: { snapshot in
            var tempMyJobs: [Job] = []
            if snapshot.hasChild("Jobs"){
                for job in snapshot.childSnapshot(forPath: "Jobs").children {
                    let tempJob = Job(snapshot: job as! FIRDataSnapshot)
                    tempMyJobs.append(tempJob)
                }
                self.myJobs = tempMyJobs
                self.tableView.reloadData()
            }
            else{
                print("User has no Jobs")
            }
        })
    }
    
    //Create table view with number of rows equal to number of Jobs user has
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myJobs.count
    }
    //Explicitly set height of table view cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    //Populate tableView cell with Job data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = "\(myJobs[indexPath.row].city), \(myJobs[indexPath.row].state) \(myJobs[indexPath.row].zipCode)"
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.detailTextLabel!.text = "\(myJobs[indexPath.row].date) \(myJobs[indexPath.row].time)\n Job Status: \(myJobs[indexPath.row].jobStatus)"
        
        //Start load image to cell
        let url = URL(string: myJobs[indexPath.row].imageURL)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SingleMyView", sender: indexPath)
    }
    
    //Prepare to seque to the appropriate VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SingleMyView"){
            let info = segue.destination as! SingleMyJobsViewController
            let tempRow = (sender as AnyObject).row
            info.job = myJobs[tempRow!]
            info.user = self.user
        }
        if(segue.identifier == "RequestJobMySegue"){
            let info = segue.destination as! RequestJobViewController
            info.user = self.user
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
