//
//  GroupTableViewCell.swift
//  Track
//
//  Created by John Yeo on 4/8/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    
    static let identifier = "GroupTableViewCell"
    
    
    public let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.textColor = .white
        return label
    }()
    
    let cellImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "checkmark")
        return image
    }()
    
    func setGroup(group: String, isSelected: Bool) {
        userNameLabel.text = group
        
        if isSelected {
            cellImageView.isHidden = false
        }
        else {
            cellImageView.isHidden = true
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(rgb: 0x202124)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(cellImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame.size.height = 70
        userNameLabel.frame = CGRect(x:  20, y: 0, width: 200, height: contentView.frame.height)
        cellImageView.frame = CGRect(x:  contentView.frame.width - 30, y: (contentView.frame.height - 15)/2, width: 17, height: 15)
    }
}
