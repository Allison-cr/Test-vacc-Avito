//
//  DetailStubView.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 10.09.2024.
//

import UIKit

final class DetailStubView: UIView {
    
    
    private var stubImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    
    private var stubSubDescriptionLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private var stubDescriptionLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private var stubUserNameLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    // Инициализатор
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
      
    }
    
    private func setupView() {
        addSubview(stubImageView)
        addSubview(stubSubDescriptionLabel)
        addSubview(stubUserNameLabel)
        addSubview(stubDescriptionLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stubImageView.startLoadingAnimation(width: 16)
        stubSubDescriptionLabel.startLoadingAnimation(width: 2)
        stubUserNameLabel.startLoadingAnimation(width: 2)
        stubDescriptionLabel.startLoadingAnimation(width: 2)
    }
    
    deinit {
        stubImageView.stopAnimating()
        stubSubDescriptionLabel.stopAnimating()
        stubUserNameLabel.stopAnimating()
        stubDescriptionLabel.stopAnimating()
    }
}

private extension DetailStubView {
    func setupLayout() {
        NSLayoutConstraint.activate([
            stubImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stubImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            stubImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            stubImageView.heightAnchor.constraint(equalToConstant: 500),
            
            stubUserNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stubUserNameLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 32),
            stubUserNameLabel.heightAnchor.constraint(equalToConstant: 8),
            stubUserNameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4),
         
            stubDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stubDescriptionLabel.topAnchor.constraint(equalTo: stubUserNameLabel.bottomAnchor, constant: 64),
            stubDescriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            stubDescriptionLabel.heightAnchor.constraint(equalToConstant: 8),
            
            stubSubDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stubSubDescriptionLabel.topAnchor.constraint(equalTo: stubDescriptionLabel.bottomAnchor, constant: 16),
            stubSubDescriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -64),
            stubSubDescriptionLabel.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
}
