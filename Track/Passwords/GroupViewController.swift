//
//  GroupViewController.swift
//  Track
//
//  Created by John Yeo on 4/8/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {

        var groupArray: [[String : Any]] = [
            [
            "group" : "Username/Email",
            "isSelected" : false
            ],
            
            [
            "group" : "Site",
            "isSelected" : false
            ],
            
            [
            "group" : "None",
            "isSelected" : false
            ]
        ]
        var isUsername: Bool = false
        var isSite: Bool = false
        var isNone: Bool = false
        
        var groupType: String?
        
        weak var delegate: PasswordListViewController?
        
        private let groupView: UIView = {
           let groupView = UIView()
            groupView.backgroundColor = UIColor(rgb: 0x202124)
            groupView.alpha = 1.0
            return groupView
        }()
        
        private let tableHeaderView: PaddingLabel = {
            let label = PaddingLabel()
            label.backgroundColor =  UIColor(rgb: 0x202124)
            label.text = "Group By"
            label.font = .systemFont(ofSize: 15, weight: .light)
            label.textColor = .lightGray
            return label
        }()
        
        private let tableView: UITableView = {
            let table = UITableView()
            table.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
            table.backgroundColor = UIColor(rgb: 0x202124)
            table.separatorColor = .clear
            table.alwaysBounceVertical = false
            return table
        }()
        
        private let cancelButton: UIButton = {
            let button = UIButton()
            button.setTitle("Cancel", for: .normal)
            button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
            button.setTitleColor(.lightGray, for: .normal)
            button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17)!
            button.backgroundColor = UIColor(rgb: 0x202124)
            return button
        }()
        
        @objc func didTapCancelButton() {
            delegate?.groupButton.tintColor = .darkGray
            dismiss(animated: true, completion: nil)
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            //set userdefaults
            let groupKey = UserDefaults.standard.value(forKey: "group") as? String ?? "username"
            
            if groupKey == "none" {
                groupArray[0]["isSelected"] = false
                groupArray[1]["isSelected"] = false
                groupArray[2]["isSelected"] = true
                
            }
            
            if groupKey == "username" {
                groupArray[0]["isSelected"] = true
                groupArray[1]["isSelected"] = false
                groupArray[2]["isSelected"] = false
                
            }
            
            if groupKey == "site" {
                groupArray[0]["isSelected"] = false
                groupArray[1]["isSelected"] = true
                groupArray[2]["isSelected"] = false
                
            }
            
            view.backgroundColor = .clear
            tableView.tableHeaderView = tableHeaderView
            tableView.delegate = self
            tableView.dataSource = self
            self.view.addSubview(groupView)
            groupView.addSubview(tableView)
            groupView.addSubview(cancelButton)
            
        }
        
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
            groupView.frame = CGRect(x: 0,
                                      y: self.view.bounds.height - self.view.bounds.height / 2 + 150,
                                      width: self.view.frame.width,
                                      height: self.view.frame.size.height - groupView.frame.origin.y)
            
            tableView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: groupView.frame.width,
                                     height: groupView.frame.height - 50)
            
            tableHeaderView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: groupView.frame.width,
                                           height: 30)
            
            cancelButton.frame = CGRect(x: 0,
                                        y: groupView.frame.size.height - 80,
                                        width: groupView.frame.size.width,
                                        height: 50)
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            print("touches began")
            delegate?.groupButton.tintColor = .darkGray
            dismiss(animated: true, completion: nil)
        }

    }

    extension GroupViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let group = groupArray[indexPath.row]

            
            let groupName = group["group"] as? String
            let groupSelected = group["isSelected"] as? Bool
            
            let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier, for: indexPath) as! GroupTableViewCell
            cell.selectionStyle = .none
            cell.setGroup(group: groupName!, isSelected: groupSelected!)
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.row == 0 {
                UserDefaults.standard.set("username", forKey: "group")
                delegate?.groupButton.tintColor = .darkGray
                delegate?.reload()
                dismiss(animated: true, completion: nil)
            }
            else if indexPath.row == 1 {
                UserDefaults.standard.set("site", forKey: "group")
                delegate?.groupButton.tintColor = .darkGray
                delegate?.reload()
                dismiss(animated: true, completion: nil)
            }
            else if indexPath.row == 2 {
                UserDefaults.standard.set("none", forKey: "group")
                delegate?.groupButton.tintColor = .darkGray
                delegate?.reload()
                dismiss(animated: true, completion: nil)
            }
            
            
        }
}




