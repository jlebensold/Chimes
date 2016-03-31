//
//  ChimeTableViewCell.swift
//  Chimes
//
//  Created by Jonathan Lebensold on 3/31/16.
//  Copyright © 2016 Jonathan Lebensold. All rights reserved.
//

import UIKit
import SQLite
class ChimeTableViewCell : UITableViewCell {
    // MARK: Properties
    
    @IBOutlet weak var chimeEnabled: UISwitch!
    
    @IBOutlet weak var chimeName: UILabel!
    
    var chimeId: Int64!
    override func awakeFromNib() {
        super.awakeFromNib();
        self.chimeEnabled.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        NSLog("Row Initialized")
    }
    
    func stateChanged(switchState: UISwitch) {
        let db = DatabaseConfiguration.init().connect()
        
        let chimeSettings = Table("chime_settings")
        let id = Expression<Int64>("id")
        let enabled = Expression<Bool?>("enabled")
        
        let chimeSetting = chimeSettings.filter(id == self.chimeId)
        
        if switchState.on {
            try! db.run(chimeSetting.update(enabled <- true))
        } else {
            try! db.run(chimeSetting.update(enabled <- false))
        }
        NSLog("Chime Setting Updated")
    }
    
    
    
}