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
    
    @IBOutlet weak var chimeDateTime: UIDatePicker!
    var chimeId: Int64!
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.chimeEnabled.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.chimeDateTime.hidden = true
        self.chimeDateTime.translatesAutoresizingMaskIntoConstraints = false
        
        NSLog("Row Initialized")
    }
    
    func hideDatePicker() {
        
        self.chimeDateTime.hidden = false
        self.chimeDateTime.alpha = 1.0
        UIView.animateWithDuration(0.25, animations: {() -> Void in
            self.chimeDateTime.alpha = 0.0
            }, completion: {(finished: Bool) -> Void in
                self.chimeDateTime.hidden = true
        })

    }
    
    func showDatePicker() {
        self.chimeDateTime.hidden = false
        self.chimeDateTime.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {() -> Void in
            self.chimeDateTime.alpha = 1.0
            }, completion: {(finished: Bool) -> Void in
                self.chimeDateTime.hidden = false
        })
        
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