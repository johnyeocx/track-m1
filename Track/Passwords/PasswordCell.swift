//
//  PasswordCell.swift
//  Track
//
//  Created by John Yeo on 26/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import UIKit

class PasswordCell: UITableViewCell {

    
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    func setPassword(password: Password) {
        
        siteLabel.text = password.site
        
        dateLabel.text = password.date
        
        usernameLabel.text = password.username
        
        return
    }
}
