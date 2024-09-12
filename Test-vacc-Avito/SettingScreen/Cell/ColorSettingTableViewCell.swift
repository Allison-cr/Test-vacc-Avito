//
//  ColorSettingTableViewCell.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 11.09.2024.
//

import UIKit

// MARK: - ColorSettingTableViewCell

final class ColorSettingTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements 
    private let colorView = UIView()
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
    
    // MARK: - Setup layout
    
    private func setupViews() {
        colorView.layer.cornerRadius = 12
        colorView.layer.borderWidth = 1
        colorView.layer.borderColor = UIColor.lightGray.cgColor
        colorView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        checkmarkImageView.tintColor = UIColor.white
        checkmarkImageView.isHidden = true
        
        contentView.addSubview(colorView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkImageView)

        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 24),
            colorView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
  
        ])
    }
    
    // MARK: - Configure
    
    func configure(with color: UIColor?, title: String, isSelected: Bool) {
        if title == "BlackAndWhite" {
            colorView.isHidden = true
            
            if contentView.subviews.contains(where: { $0 is BlackAndWhiteCircleView }) {
               
                return
            }

            let blackAndWhiteCircle = BlackAndWhiteCircleView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            blackAndWhiteCircle.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(blackAndWhiteCircle)
            
            NSLayoutConstraint.activate([
                blackAndWhiteCircle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                blackAndWhiteCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                blackAndWhiteCircle.widthAnchor.constraint(equalToConstant: 24),
                blackAndWhiteCircle.heightAnchor.constraint(equalToConstant: 24)
            ])
        } else if title == "Any" {
            colorView.isHidden = true
        } else {
            colorView.isHidden = false
            colorView.backgroundColor = color
            for view in contentView.subviews {
                if view is BlackAndWhiteCircleView {
                    view.removeFromSuperview()
                }
            }
        }
        
        titleLabel.text = title
        checkmarkImageView.isHidden = !isSelected
    }
}
