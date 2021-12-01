//
//  ItemCell.swift
//  Track
//
//  Created by John Yeo on 26/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import UIKit

class ItemCell: UITableViewCell {

    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var rememberLabel: UILabel!
    
    func setItem(item: Item) {
        itemLabel.text = item.item
        rememberLabel.text = item.location
    }
}

