//
//  CustomTableViewCell.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 11.09.2024.
//

import UIKit

// MARK: - CustomTableViewCell

final class CustomTableViewCell: UITableViewCell {
    
    // MARK: Variables
    
    private let titleLabel = UILabel()
    private let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
    
    
    // MARK: Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setupView
    
    private func setupViews() {
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkImageView)
        
        // Configure checkmarkImageView
        checkmarkImageView.tintColor = UIColor.white
        checkmarkImageView.isHidden = true
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        contentView.backgroundColor = Colors.settingTableColor
    }
    
    // MARK: - Configure 
    
    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        checkmarkImageView.isHidden = !isSelected
    }
}
