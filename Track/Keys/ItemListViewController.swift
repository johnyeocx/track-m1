//
//  KeyListViewController.swift
//  Track
//
//  Created by John Yeo on 20/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import UIKit

class ItemListViewController: UIViewController, UINavigationControllerDelegate, UISearchBarDelegate {
 
        
    @IBOutlet weak var tableView: UITableView!
    
        var items: [Item] = []
        
        func reload () {
            items = ItemManager.main.getAllItems()
//            print(items)
            tableView.reloadData()
            setBackgroundView()
        }
    
    private let editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(editButtonTapped))
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ], for: .normal)
        return button
    }()
    
    private let inputPageButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(inputButtonTapped))
        button.tintColor = .darkGray
        return button
    }()
    
    private let tableHeaderView: UIView = {
        let tableHeaderView = UIView()
        tableHeaderView.backgroundColor = UIColor(rgb: 0xFF91BA)
        return tableHeaderView
    }()
    
//    private let searchBarButton: UIButton = {
//        let searchBarButton = UIButton()
//        searchBarButton.tintColor = UIColor.darkGray
//        searchBarButton.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
//        searchBarButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
//        searchBarButton.frame = CGRect(x: 20, y: 3, width: 32, height: 30)
//        return searchBarButton
//    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.searchTextField.tintColor = .lightGray
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.backgroundColor = UIColor(rgb: 0xFF91BA)
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
    
    @objc func searchButtonPressed() {
        print("search Button Tapped")
    }
    
    @objc func inputButtonTapped() {
        print("input button tapped")
        performSegue(withIdentifier: "ItemInputSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        let inputButton = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(inputButtonTapped))
        inputButton.tintColor = .darkGray

        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(editButtonTapped))
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ], for: .normal)
        self.navigationItem.leftBarButtonItem = button
        self.navigationItem.rightBarButtonItem = inputButton
//        tableView.tableHeaderView = tableHeaderView
//        tableHeaderView.addSubview(searchBarButton)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.tintColor = UIColor(rgb: 0xFF91BA)
        let footerView = UIView()
        footerView.backgroundColor = .black
        tableView.tableFooterView = footerView
        tableView.backgroundColor = .black
        reload()

    }
    @objc func editButtonTapped () {
        print("editButtonTapped")
    }
    
    
        
    

    func setBackgroundView() {
        if tableView.numberOfRows(inSection: 0) > 0 {
            self.tableView.backgroundView = nil

        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            noDataLabel.text = "No Items"
            noDataLabel.font = UIFont(name: "Helvetica Neue", size: 20)
            noDataLabel.textAlignment = NSTextAlignment.center
            noDataLabel.textColor = .lightGray
            self.tableView.backgroundView = noDataLabel
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemSegue" {
            let des = segue.destination as? ItemViewController
            des!.item = items[tableView.indexPathForSelectedRow!.row]
            des!.delegate = self
        }
        //
        if segue.identifier == "ItemInputSegue" {
            let des = segue.destination as! ItemInputViewController
            des.delegate = self
        }
    }

    }

extension ItemListViewController: UITableViewDataSource, UITableViewDelegate {

        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
            let item = items[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
            cell.setItem(item: item)
            
//            if indexPath.section == 0 {
//                cell.selectionStyle = .none
//            } else {
//                cell.selectionStyle = .default
//            }
            return cell
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

            ItemManager.main.delete(item: self.items[indexPath.row])
            self.items.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.setBackgroundView()

    //            self.passwords.remove(at: indexPath.row)
    //            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            action.backgroundColor = .systemRed
            return action
        }
        

}
