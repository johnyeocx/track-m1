//
//  PasswordInputController.swift
//  Track
//
//  Created by John Yeo on 26/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import UIKit


class PasswordInputViewController: UIViewController, UITextFieldDelegate{
    
    var password: Password!
    var passwords: [Password] = []
    
    @IBAction func dismissInput() {
        dismiss(animated: true, completion: nil)
    }
    
    
    //comment
    weak var delegate: PasswordListViewController?
    
    @IBOutlet weak var passwordSite: UITextField!
    @IBOutlet weak var passwordUsername: UITextField!
    @IBOutlet weak var siteView: UIView!
    @IBOutlet weak var passwordPassword: UITextField!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet var overallVIew: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordSite.delegate = self
        passwordUsername.delegate = self
        passwordPassword.delegate = self
        passwordSite.tag = 1
        passwordUsername.tag = 2
        passwordPassword.tag = 3

        passwordSite.text = ""
        passwordUsername.text = ""
        passwordPassword.text = ""

//        inputHeader.clipsToBounds = true
//        inputHeader.layer.cornerRadius = 30
//        inputHeader.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        siteView.layer.borderWidth = 2.0
        siteView.layer.cornerRadius = 20.0
        siteView.layer.borderColor = UIColor(rgb: 0xECF751).cgColor
        
        usernameView.layer.borderWidth = 2.0
        usernameView.layer.cornerRadius = 20.0
        usernameView.layer.borderColor = UIColor(rgb: 0xECF751).cgColor
        
        passwordView.layer.borderWidth = 2.0
        passwordView.layer.cornerRadius = 20.0
        passwordView.layer.borderColor = UIColor(rgb: 0xECF751).cgColor
        
        enterButton.layer.borderWidth = 2.0
        enterButton.layer.cornerRadius = 20.0
        enterButton.layer.borderColor = UIColor(rgb: 0xECF751).cgColor


        overallVIew.clipsToBounds = true
        overallVIew.layer.cornerRadius = 30
        overallVIew.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }



//
//
//
    @IBAction func enterTapped() {
        
        print("enter button tapped")
        
        guard let passwordSite = passwordSite.text,
            let passwordUsername = passwordUsername.text,
            let passwordPassword = passwordPassword.text,
            !passwordSite.isEmpty,
            !passwordUsername.isEmpty,
            !passwordPassword.isEmpty else {
            print("one field empty")
                return
        }
        
        let lastRowId = PasswordManager.main.getLastRowId()
        
        // get date as a string
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let dateTimeString = formatter.string(from: currentDateTime)

        password = Password(id: lastRowId, site: passwordSite, username:  passwordUsername, password: passwordPassword, date: dateTimeString)

        let _ = PasswordManager.main.create(password: password)
        delegate?.reload()
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         if textField.tag == 1 {
             
             passwordUsername.becomeFirstResponder()
    
             }
         else if textField.tag == 2 {
            passwordPassword.becomeFirstResponder()
        }
         else {
            passwordPassword.resignFirstResponder()
        }
        return true
     }

}
