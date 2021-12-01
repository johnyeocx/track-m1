//
//  ViewController.swift
//  Track
//
//  Created by John Yeo on 19/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import UIKit

class TrackListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    var tracks = [Track]()
    var segueIdentifiers = ["PaymentSegue", "KeySegue", "PasswordSegue", "CustomSegue"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tracks = createArray()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func createArray() -> [Track] {
        
        var tempTrack: [Track] = []
        
        let track1 = Track(message: "Payments")
        let track2 = Track(message: "Keys")
        let track3 = Track(message: "Passwords")
        let track4 = Track(message: "Custom")
        
        tempTrack.append(track1)
        tempTrack.append(track2)
        tempTrack.append(track3)
        tempTrack.append(track4)
        
        return tempTrack
    }

    
}

extension TrackListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let track = tracks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell") as! TrackCell
        
        cell.setTrack(track: track)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segue = segueIdentifiers[indexPath.row]
        performSegue(withIdentifier: segue, sender: self)
    }
}

