//
//  MyJobsViewController.swift
//  ZephyrApp
//
//  Created by Hannah Mehrle on 11/17/16.
//  Copyright © 2016 Hannah Mehrle. All rights reserved.
//

import Foundation
import UIKit

class MyJobsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var dummyJobs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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
        dummyJobs.removeAll()
        dummyJobs.append("my first job")
        dummyJobs.append("my second job")
        dummyJobs.append("my third job")
        dummyJobs.append("my fourth job")
        dummyJobs.append("my fifth job")
        self.tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SingleMyView"){
            let info = segue.destination as! SingleMyJobsViewController
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
        self.performSegue(withIdentifier: "SingleMyView", sender: indexPath)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
