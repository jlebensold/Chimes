//
//  SettingsViewController.swift
//  Chimes
//
//  Created by Jonathan Lebensold on 3/31/16.
//  Copyright © 2016 Jonathan Lebensold. All rights reserved.
//

import UIKit
import SQLite

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var items: [Dictionary<String, Any?>] = []
    let db = DatabaseConfiguration.init().connect()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        NSLog("Settings View Loaded")
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let stmt = try! db.prepare("SELECT id, enabled, key, name FROM chime_settings")
        
        
        for row in stmt {
            NSLog("id: \(row[0]!), enabled: \(row[1]!), key: \(row[2]!), name: \(row[3]!)")
            items.append(["enabled": Int(row[1] as! Int64) == 1, "key": "\(row[2]!)", "name": "\(row[3]!)", "id": row[0] as! Int64])
        }
        
    
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ChimeTableViewCell"

        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChimeTableViewCell
        
        cell.chimeId = self.items[indexPath.row]["id"] as! Int64
        cell.chimeName.text = self.items[indexPath.row]["name"] as! String
        cell.chimeEnabled.on = self.items[indexPath.row]["enabled"] as! Bool
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    
}