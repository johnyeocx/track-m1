//
//  PasswordViewController.swift
//  Track
//
//  Created by John Yeo on 26/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import UIKit

class PasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var siteLabel: UITextField!
    @IBOutlet weak var userLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    weak var delegate: PasswordListViewController?
    var password: Password!
    @IBOutlet weak var headerView: RadialGradientView!
    
    var iconClick = true
    
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
        delegate?.reload()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        headerView.addSubview(dismissButton)
        siteLabel.delegate = self
        userLabel.delegate = self
        passwordLabel.delegate = self
        super.viewDidLoad()
        siteLabel.text = password.site
        userLabel.text = password.username
        passwordLabel.text = password.password
        passwordLabel.isSecureTextEntry = true
    }
    
    @IBAction func enterTapped() {
        password.site = siteLabel.text!
        password.username = userLabel.text!
        password.password = passwordLabel.text!
        PasswordManager.main.save(password: password)
        delegate?.reload()
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func hideTextField(sender: AnyObject) {
        if(iconClick == true) {
            passwordLabel.isSecureTextEntry = false
        } else {
            passwordLabel.isSecureTextEntry = true
        }

        iconClick = !iconClick
    }

}
