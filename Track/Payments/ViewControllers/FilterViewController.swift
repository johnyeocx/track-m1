//
//  FilterViewController.swift
//  Track
//
//  Created by John Yeo on 3/8/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    var filterArray: [[String : Any]] = [
        [
        "filter" : "Name",
        "isSelected" : false
        ],
        
        [
        "filter" : "Amount",
        "isSelected" : false
        ],
        
        [
        "filter" : "Recently Added",
        "isSelected" : false
        ]
    ]
    var isRecent: Bool = false
    var isName: Bool = false
    var isAmount: Bool = false
    
    var filterType: String?
    
    weak var delegate: PaymentListViewController?
    
    private let filterView: UIView = {
       let filterView = UIView()
        filterView.backgroundColor = UIColor(rgb: 0x202124)
        filterView.alpha = 1.0
        return filterView
    }()
    
    private let tableHeaderView: PaddingLabel = {
        let label = PaddingLabel()
        label.backgroundColor =  UIColor(rgb: 0x202124)
        label.text = "Sort By"
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .lightGray
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.identifier)
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
        delegate?.filterButton.tintColor = .darkGray
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //set userdefaults
        let filterKey = UserDefaults.standard.value(forKey: "filter") as? String ?? "recent"
        
        if filterKey == "recent" {
            filterArray[0]["isSelected"] = false
            filterArray[1]["isSelected"] = false
            filterArray[2]["isSelected"] = true
            
            isRecent = true
            isName = false
            isAmount = false
        }
        
        if filterKey == "name" {
            filterArray[0]["isSelected"] = true
            filterArray[1]["isSelected"] = false
            filterArray[2]["isSelected"] = false
            
            isRecent = false
            isName = true
            isAmount = false
        }
        
        if filterKey == "amount" {
            filterArray[0]["isSelected"] = false
            filterArray[1]["isSelected"] = true
            filterArray[2]["isSelected"] = false
            
            isRecent = false
            isName = false
            isAmount = true
        }
        
        view.backgroundColor = .clear
        tableView.tableHeaderView = tableHeaderView
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(filterView)
        filterView.addSubview(tableView)
        filterView.addSubview(cancelButton)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        filterView.frame = CGRect(x: 0,
                                  y: self.view.bounds.height - self.view.bounds.height / 2 + 150,
                                  width: self.view.frame.width,
                                  height: self.view.frame.size.height - filterView.frame.origin.y)
        
        tableView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: filterView.frame.width,
                                 height: filterView.frame.height - 50)
        
        tableHeaderView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: filterView.frame.width,
                                       height: 30)
        
        cancelButton.frame = CGRect(x: 0,
                                    y: filterView.frame.size.height - 80,
                                    width: filterView.frame.size.width,
                                    height: 50)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches began")
        delegate?.filterButton.tintColor = .darkGray
        dismiss(animated: true, completion: nil)
    }

}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filter = filterArray[indexPath.row]

        
        let filterName = filter["filter"] as? String
        let filterSelected = filter["isSelected"] as? Bool
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as! FilterTableViewCell
        cell.selectionStyle = .none
        cell.setFilter(filter: filterName!, isSelected: filterSelected!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            UserDefaults.standard.set("name", forKey: "filter")
            delegate?.filterButton.tintColor = .darkGray
            delegate?.reload()
            dismiss(animated: true, completion: nil)
        }
        else if indexPath.row == 1 {
            UserDefaults.standard.set("amount", forKey: "filter")
            delegate?.filterButton.tintColor = .darkGray
            delegate?.reload()
            dismiss(animated: true, completion: nil)
        }
        else if indexPath.row == 2 {
            UserDefaults.standard.set("recent", forKey: "filter")
            delegate?.filterButton.tintColor = .darkGray
            delegate?.reload()
            dismiss(animated: true, completion: nil)
        }
        
        
    }
}

// padding label
@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 10.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 20.0
    @IBInspectable var rightInset: CGFloat = 16.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
