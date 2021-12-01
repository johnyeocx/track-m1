//
//  ItemViewController.swift
//  Track
//
//  Created by John Yeo on 26/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import UIKit

class ItemViewController: UIViewController, UITextFieldDelegate {
    
    var item: Item!
    
    @IBOutlet weak var itemLabel: UITextField!
    @IBOutlet weak var headerView: RadialGradientView!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var otherLabel: UITextView!
    
    weak var delegate: ItemListViewController?
    
    override func viewDidLoad() {
        itemLabel.delegate = self
        locationLabel.delegate = self

        super.viewDidLoad()
        
        
        otherLabel.text = item.others
        dateLabel.text = item.date
        itemLabel.text = item.item
        locationLabel.text = item.location
        
        if locationLabel.text == "" {
            locationLabel.text = "Add To Remember:"
        }
        if otherLabel.text == "" {
            otherLabel.text = "Add Notes:"
        }
        
        headerView.addSubview(dismissButton)
    }
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowshape.turn.up.left.fill"), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
        button.tintColor = .darkGray
        return button
    }()
    
    @objc func dismissButtonTapped() {
        print("dismiss button tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func enterTapped() {
        
        guard let itemLabel = itemLabel.text,
            let itemLocation = locationLabel.text,
            let itemDate = dateLabel.text,
            let itemOthers = otherLabel.text,
            !itemLabel.isEmpty else {
                return
        }
        
        item.date = itemDate
        item.item = itemLabel
        item.location = itemLocation
        item.others = itemOthers
        
        ItemManager.main.save(item: item)
        delegate?.reload()
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }

}
