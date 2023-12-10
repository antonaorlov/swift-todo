//
//  CustomTableViewCell.swift
//  Checklists
//
//  Created by user243761 on 12/9/23.
//

import UIKit
class CustomTableViewCell: UITableViewCell {
    
    let itemLabel = UILabel()
    let checkboxImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        // Add itemLabel and checkboxImageView to the cell's content view
        // Setup constraints or use autoresizing
        // For example:
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        checkboxImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(itemLabel)
        contentView.addSubview(checkboxImageView)
        // ... Add constraints or set autoresizing masks ...
    }

    func configure(with item: ChecklistItem) {
        // Configure the cell with data from the ChecklistItem
        itemLabel.text = item.text
        // Set the checkbox image based on the item's checked status
        checkboxImageView.image = item.checked ? UIImage(named: "checkedImageName") : UIImage(named: "uncheckedImageName")
    }
}
