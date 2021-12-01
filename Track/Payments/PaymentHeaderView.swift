//
//  PaymentHeaderView.swift
//  Track
//
//  Created by John Yeo on 21/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import UIKit

class PaymentHeaderView: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
