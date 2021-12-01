//
//  PasswordListViewController.swift
//  Track
//
//  Created by John Yeo on 25/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import UIKit

struct Section {
    let username: String
    var passwords: [Password]
}

class PasswordListViewController: UIViewController, UISearchBarDelegate {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    var IsEditing = false
    
    
    var passwords: [Password] = []
    var currentPasswords = [Password]()
    var usernames = [String]()
    var sections = [Section]()
    
    @IBAction func startEditing() {
        print(IsEditing)
        
        if IsEditing == true {
            editButton.title = "Edit"
        }
        if IsEditing == false {
            editButton.title = "Done"
        }

        tableView.setEditing(!IsEditing, animated: true)
        
        IsEditing = !IsEditing
    }
    
//    private let searchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.searchTextField.tintColor = .lightGray
//        searchBar.searchTextField.textColor = .white
//        searchBar.backgroundColor = UIColor(rgb: 0xECF751)
//        searchBar.searchTextField.backgroundColor = .darkGray
//        searchBar.showsCancelButton = true
//        searchBar.searchBarStyle = .minimal
//        searchBar.searchTextField.leftView?.tintColor = .lightGray
//        let attributes:[NSAttributedString.Key: Any] = [
//            .foregroundColor: UIColor.darkGray,
//            .font: UIFont(name: "HelveticaNeue-Bold", size: 17)!
//        ]
//        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
//        return searchBar
//    }()
    
    private let tableHeaderView: UIView = {
        let tableHeaderView = UIView()
        tableHeaderView.backgroundColor = UIColor(rgb: 0xECF751)
        return tableHeaderView
    }()
    
//    private let searchBarButton: UIButton = {
//        let searchBarButton = UIButton()
//        searchBarButton.tintColor = UIColor.darkGray
//        searchBarButton.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
//        searchBarButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
//        searchBarButton.frame = CGRect(x: 16, y: 10, width: 32, height: 30)
//        return searchBarButton
//    }()
    
    public let groupButton: UIButton = {
        let groupButton = UIButton()
        groupButton.tintColor = UIColor.darkGray
        groupButton.setBackgroundImage(UIImage(systemName: "folder.circle.fill"), for: .normal)
        groupButton.addTarget(self, action: #selector(groupButtonPressed), for: .touchUpInside)
        groupButton.frame = CGRect(x: 20, y: 3, width: 32, height: 30)
        return groupButton
    }()
    
    @objc func groupButtonPressed() {
        
        groupButton.tintColor = .white
        let modalViewController = GroupViewController()
        modalViewController.delegate = self
        navigationController?.present(modalViewController, animated: true, completion: nil)
    }
    
//    @objc func searchButtonPressed() {
//        // bring searchBar into headerView
//        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
//            self.searchBar.alpha = 1
//            self.tableHeaderView.addSubview(self.searchBar)
//            self.searchBar.becomeFirstResponder()
//        }, completion: nil)
//    }
    
    
    
    func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.tableHeaderView.alpha = 1
            self.tableHeaderView.frame.size.height = 45// Here you will get the animation you want
        }, completion: { _ in
            // Here you hide it when animation done
        })
        searchBar.resignFirstResponder()
        searchBar.text = ""
        currentPasswords = passwords
        reload()

    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                self.tableHeaderView.alpha = 0
                self.tableHeaderView.frame.size.height = 0 // Here you will get the animation you want
            }, completion: { _ in
    // Here you hide it when animation done
            })
        tableView.reloadData()
        return true
        }
    
    
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        reload()
//        return
//    }
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        
        //        searchController.searchBar.showsBookmarkButton = true
        //        searchController.searchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease.circle.fill"), for: .bookmark, state: .normal)
        //        searchController.searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .bookmark)
        
        searchController.searchBar.searchTextField.tintColor = .lightGray
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.backgroundColor = UIColor(rgb: 0xECF751)
        searchController.searchBar.searchTextField.backgroundColor = .darkGray
        //        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.searchTextField.leftView?.tintColor = .lightGray
        let attributes:[NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGray,
            .font: UIFont(name: "HelveticaNeue-Bold", size: 17)!
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        return searchController
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentPasswords = passwords
            groupTableView()
            tableView.reloadData()
            return
        }
        currentPasswords = passwords.filter({ password -> Bool in
            guard let text = searchBar.text else {return false}
            return password.site.lowercased().contains(text.lowercased()) || password.username.lowercased().contains(text.lowercased())
        })
        groupTableView()
        tableView.reloadData()
    }
    
    func reload () {
        IsEditing = false
        isEditing = false
        
        passwords = PasswordManager.main.getAllPasswords()
        currentPasswords = passwords
        print(passwords)
        
        groupTableView()

        self.tableView.reloadData()
        setBackgroundView()
        setEditButton()

        
    }
    
    func groupTableView() {
        
        let groupKey = UserDefaults.standard.value(forKey: "group") as? String ?? "username"
        
        if groupKey == "username" {
            let groupedDictionary = Dictionary(grouping: currentPasswords, by: { $0.username })
            let keys = groupedDictionary.keys.sorted()
            sections = keys.map{ Section(username: $0, passwords: groupedDictionary[$0]!) }
        }
        
        else if groupKey == "site" {
            let groupedDictionary = Dictionary(grouping: currentPasswords, by: { $0.site })
            let keys = groupedDictionary.keys.sorted()
            sections = keys.map{ Section(username: $0, passwords: groupedDictionary[$0]!) }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //implement grouping
        reload()
        tableView.tableHeaderView = tableHeaderView
//        tableHeaderView.addSubview(searchBarButton)
        tableHeaderView.addSubview(self.groupButton)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(rgb: 0xECF751)
//        searchBar.delegate = self
        setupNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45)
//        clearHistoryButton.frame = CGRect(x: self.view.frame.size.width - 130, y: 0, width: 150, height: 50)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.tintColor = UIColor(rgb: 0xECF751)
        let footerView = UIView()
        footerView.backgroundColor = .black
        tableView.tableFooterView = footerView
        tableView.backgroundColor = .black
        tableView.separatorColor = .darkGray
        reload()

    }

    func setBackgroundView() {
        if tableView.numberOfRows(inSection: 0) > 0 {
            self.tableView.backgroundView = nil
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.systemTeal
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            noDataLabel.text = "No Passwords"
            noDataLabel.font = UIFont(name: "Helvetica Neue", size: 20)
            noDataLabel.textAlignment = NSTextAlignment.center
            noDataLabel.textColor = .lightGray
            self.tableView.backgroundView = noDataLabel
            setEditButton()
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PasswordSegue" {
            let des = segue.destination as? PasswordViewController
            
            let groupKey = UserDefaults.standard.value(forKey: "group") as? String ?? "username"
            
            if groupKey == "username" || groupKey ==  "site" {
                let section = sections[tableView.indexPathForSelectedRow!.section]
                des?.password = section.passwords[tableView.indexPathForSelectedRow!.row]
                des?.delegate = self
            }
            else {
                des!.password = currentPasswords[tableView.indexPathForSelectedRow!.row]
                des!.delegate = self
            }
        }
        
        if segue.identifier == "PasswordInputSegue" {
            let des = segue.destination as! PasswordInputViewController
            des.delegate = self
        }
    }
    
    func setEditButton() {
        editButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray
            ], for: .normal)
            
            tableView.setEditing(false, animated: true)
            IsEditing = false
            editButton.title = "Edit"
    }
    
}

extension PasswordListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        if sections.count == 0 {
            return 1
        }
        let groupKey = UserDefaults.standard.value(forKey: "group") as? String ?? "username"
        
        if groupKey == "username" || groupKey ==  "site" {
            return sections.count
        }
        else {
            return 1
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let groupKey = UserDefaults.standard.value(forKey: "group") as? String ?? "username"
        
        if groupKey == "none" {
            return currentPasswords.count
        }
        if sections.count == 0 {
            return 0
        }
        if groupKey == "username" || groupKey ==  "site" {
            return sections[section].passwords.count
        }
        else {
            return currentPasswords.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let groupKey = UserDefaults.standard.value(forKey: "group") as? String ?? "username"
        
        if groupKey == "username" || groupKey ==  "site" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordCell", for: indexPath) as! PasswordCell
            let section = sections[indexPath.section]
            
            let password = section.passwords[indexPath.row]
            
            cell.setPassword(password: password)
            return cell
        }
        else {
            print("current group is none")
            let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordCell", for: indexPath) as! PasswordCell
            let password = currentPasswords[indexPath.row]
            cell.setPassword(password: password)
            return cell
        }
    }
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let groupKey = UserDefaults.standard.value(forKey: "group") as? String ?? "username"
        
        if sections.count == 0 {
            return nil
        }
        
        if groupKey == "username" || groupKey ==  "site" {
            return sections[section].username
        }
        else {
            return nil
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 78
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    

    func deleteAction(at indexPath:IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            let groupKey = UserDefaults.standard.value(forKey: "group") as? String ?? "username"
            
            if groupKey == "none" {
                print("deleted none passwords")
//                self.sections[indexPath.section].passwords.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .left)
                let password = self.currentPasswords[indexPath.row]
                PasswordManager.main.delete(password: password)
                self.currentPasswords.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)

            }
            
            if groupKey == "username" || groupKey ==  "site" {
                let section = self.sections[indexPath.section]
                let password = section.passwords[indexPath.row]
                PasswordManager.main.delete(password: password)
                self.sections[indexPath.section].passwords.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }
            self.reload()
            self.setBackgroundView()
        }
        
        action.backgroundColor = .systemRed
        return action
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 0, width: 320, height: 30)
        myLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)!
        myLabel.textColor = .lightGray
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

        let headerView = UIView()
        headerView.addSubview(myLabel)
        headerView.backgroundColor = .darkGray
        
        let groupKey = UserDefaults.standard.value(forKey: "group") as? String ?? "username"
        
        if groupKey == "username" || groupKey ==  "site" {
            headerView.isHidden = false
        }
        else {
            headerView.isHidden = true
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let groupKey = UserDefaults.standard.value(forKey: "group") as? String ?? "username"
        
        if sections.count == 0 {
            return 0
        }
        
        if groupKey == "username" || groupKey ==  "site" {
            return 30
        }
        else {
            return 0
        }
    }

}


