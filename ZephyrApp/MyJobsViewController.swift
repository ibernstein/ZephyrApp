//
//  MyJobsViewController.swift
//  ZephyrApp
//
//  Created by Hannah Mehrle on 11/17/16.
//  Copyright © 2016 Hannah Mehrle. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MyJobsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ref = FIRDatabase.database().reference()
    var tableView: UITableView!
    var myJobs: [Job]=[]
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        let firstTab = self.tabBarController?.viewControllers?[0] as! UINavigationController
        let info = firstTab.viewControllers[0] as! AvailableJobsViewController
        self.user = info.user
        print("Available Jobs as info: \(info.user.userId)")
        print("My Jobs as self: \(self.user.userId)")
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
    func fetchDataForTableView(){
        print("Got into fetchDataForTabelView")
        self.myJobs.removeAll()
        print(self.user.userId)
        let userRef = ref.child("Users").child(self.user.userId)
        print("Got past userRef")
        userRef.observe(.value, with: { snapshot in
            print("into observe")
            if snapshot.hasChild("Jobs"){
                print("past has Child when shouldn't be")
                for job in snapshot.children {
                    let tempJob = Job(snapshot: job as! FIRDataSnapshot)
                    self.myJobs.append(tempJob)
                }
            }
            else{
                print("User has no Jobs")
            }
        })
        self.tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SingleMyView"){
            let info = segue.destination as! SingleMyJobsViewController
            let tempRow = (sender as AnyObject).row
            info.job = myJobs[tempRow!]
            info.user = self.user
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myJobs.count
    }
    
    //Change height of table view cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    //Get a random stock house image url
//    func getRandomHouseImageURL() -> String {
//        let houseImageURLs: [String] = ["http://p.rdcpix.com/v03/l1fa99e44-m0xd-w1020_h770_q80.jpg", "http://ap.rdcpix.com/264218382/c80f65112de01d0d92f90820a142b380l-m0xd-w640_h480_q80.jpg", "https://s-media-cache-ak0.pinimg.com/originals/bf/e2/5b/bfe25bcfb3e0136373dfb5dac55d8567.jpg", "http://ap.rdcpix.com/1497074664/f949b0bb676a540d079e8a68b79edc95l-m0xd-w640_h480_q80.jpg", "http://p.rdcpix.com/v03/lb0e5cc44-m0xd-w1020_h770_q80.jpg", "https://nextstl.com/wp-content/uploads/12739334805_0ec55c456c_o.jpg", "http://p.rdcpix.com/v04/l3fdd4f45-m0xd-w640_h480_q80.jpg", "https://8a395db01df29f9e7734-495423e69c978983374849b9c24303fc.ssl.cf5.rackcdn.com/16040450-residential-jl5cwb-l.jpg", "http://ap.rdcpix.com/1499641782/0851d1521d331d1de9835d6535995f39l-m0xd-w640_h480_q80.jpg", "http://robbpartners.com/wp-content/uploads/2013/11/511-W-polo-Clayton.jpg", "https://upload.wikimedia.org/wikipedia/commons/7/76/Whittemore_House_Club_Clayton_MO.jpg", "http://www.jimbergteam.com/images/featured/1950247759.JPG", "http://www.claytonhistorysociety.org/imageshanleyhouse/hanleyhouse.jpg", "http://media.point2.com/p2a/themeresource/9393/bd28/8797/05eeda72b204c85bdce2/Original.jpg", "http://media.theweek.com/img/generic/HH1101_MO.jpg", "http://photos.zillowstatic.com/p_e/ISivvsxbi4os5g0000000000.jpg", "http://photos.zillowstatic.com/p_e/ISq9oq0kzi0o040000000000.jpg" ] //17 image URLs
//        let numURLs = houseImageURLs.count
//        let randomNum = Int(arc4random_uniform(UInt32(numURLs)))
//        let chosenURL = houseImageURLs[randomNum]
//        return chosenURL
//    } we're doing this in requestJobVC now
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = "\(myJobs[indexPath.row].city), \(myJobs[indexPath.row].state) \(myJobs[indexPath.row].zipCode)"
        cell.detailTextLabel!.text = "\(myJobs[indexPath.row].date) \(myJobs[indexPath.row].time)"
        
        //START image stuff
        let url = URL(string: myJobs[indexPath.row].imageURL)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catcht
        cell.imageView?.image = UIImage(data: data!)
        //END image stuff
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SingleMyView", sender: indexPath)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
