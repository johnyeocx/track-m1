//
//  TrackCell.swift
//  Track
//
//  Created by John Yeo on 19/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import UIKit

class TrackCell: UITableViewCell {
    
    @IBOutlet weak var trackLabel: UILabel!
    
    func setTrack(track: Track) {
        trackLabel.text = track.message
        return
    }
}
