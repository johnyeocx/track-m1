//
//  ItemInputController.swift
//  Track
//
//  Created by John Yeo on 26/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import UIKit


class ItemInputViewController: UIViewController, UITextFieldDelegate{
    
    var item: Item!
    var items: [Item] = []
    
    @IBAction func dismissInput() {
        dismiss(animated: true, completion: nil)
    }
    
    //comment
    weak var delegate: ItemListViewController?
    

    @IBOutlet weak var inputHeader: UILabel!
    
    @IBOutlet var overallView: UIView!
    

    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var itemItem: UITextField!

    @IBOutlet weak var itemLocation: UITextField!
    
    @IBOutlet weak var itemOthers: UITextField!
    
    @IBOutlet weak var othersView: UIView!
    
    @IBOutlet weak var remembranceView: UIView!
    
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemItem.delegate = self
        itemLocation.delegate = self
        itemItem.tag = 1
        itemLocation.tag = 2

        itemItem.text = ""
        itemLocation.text = ""
        itemOthers.text = ""
        

//        inputHeader.clipsToBounds = true
//        inputHeader.layer.cornerRadius = 30
//        inputHeader.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]


        overallView.clipsToBounds = true
        overallView.layer.cornerRadius = 30
        overallView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        itemView.layer.borderWidth = 2.0
        itemView.layer.cornerRadius = 20.0
        itemView.layer.borderColor = UIColor(rgb: 0xFF91BA).cgColor
        
        remembranceView.layer.borderWidth = 2.0
        remembranceView.layer.cornerRadius = 20.0
        remembranceView.layer.borderColor = UIColor(rgb: 0xFF91BA).cgColor
        
        othersView.layer.borderWidth = 2.0
        othersView.layer.cornerRadius = 20.0
        othersView.layer.borderColor = UIColor(rgb: 0xFF91BA).cgColor
        
        enterButton.layer.borderWidth = 2.0
        enterButton.layer.cornerRadius = 20.0
        enterButton.layer.borderColor = UIColor(rgb: 0xFF91BA).cgColor
        
    }



//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
//                nextField.becomeFirstResponder()
//            } else {
//                // Not found, so remove keyboard.
//                textField.resignFirstResponder()
//            }
//            // Do not add a line break
//            return false
//    }


//
//
//
    @IBAction func enterTapped() {
        let lastRowId = ItemManager.main.getLastRowId()
        
        guard let itemItem = itemItem.text,
            let itemLocation = itemLocation.text,
            let itemOthers = itemOthers.text,
            !itemItem.isEmpty else {
                return
        }
        
        // get today's date in a string
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let dateTimeString = formatter.string(from: currentDateTime)
        
        item = Item(id: lastRowId, item: itemItem, location:  itemLocation, others: itemOthers, date: dateTimeString)

        let _ = ItemManager.main.create(item: item)
        delegate?.reload()
        self.dismiss(animated: true, completion: nil)
    }
}
