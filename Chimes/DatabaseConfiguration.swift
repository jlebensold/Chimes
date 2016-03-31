//
//  DatabaseConfiguration.swift
//  Chimes
//
//  Created by Jonathan Lebensold on 3/31/16.
//  Copyright © 2016 Jonathan Lebensold. All rights reserved.
//

import Foundation
import SQLite

@objc(DatabaseConfiguration)
class DatabaseConfiguration: NSObject {

    override init() {
        super.init()
    }
    
    func connect() -> Connection {
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first!
        
        return try! Connection("\(path)/db.sqlite3")
    }
    
    @objc func setup() -> Void {
        let db = connect()
        let options = Table("options")
        let chimeSettings = Table("chime_settings")
        // obviously, we would not do this every time the app loads!
        try! db.run(options.drop(ifExists: true))
        try! db.run(chimeSettings.drop(ifExists: true) )
        
        

        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let value = Expression<String?>("value")
        let run = try! db.run(options.create { t in
            t.column(id, primaryKey: true)
            t.column(name, unique: true)
            t.column(value)
            })
        
        
        let enabled = Expression<Bool?>("enabled")
        let key = Expression<Int?>("key")
        let chimeRun = try! db.run(chimeSettings.create { t in
            t.column(id, primaryKey: true)
            t.column(key, unique: true)
            t.column(name, unique: true)
            t.column(enabled)
            })
        
        
        try! db.run(options.insert(value <- "06:00", name <- "start_time"))
        try! db.run(options.insert(value <- "16:00", name <- "stop_time"))

        try! db.run(chimeSettings.insert(enabled <- true, key <- 60, name <- "On the Hour"))
        try! db.run(chimeSettings.insert(enabled <- false, key <- 15, name <- "On the Quarter Hour"))

        let stmt = try! db.prepare("SELECT id, enabled, key, name FROM chime_settings")
        for row in stmt {
            NSLog("id: \(row[0]!), enabled: \(row[1]!), key: \(row[2]!), name: \(row[3]!)")
            for (index, name) in stmt.columnNames.enumerate() {
                NSLog ("\(name)=\(row[index]!)")
                
            }
        }
        
    }
}