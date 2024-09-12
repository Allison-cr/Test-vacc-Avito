//
//  TopicCell.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 11.09.2024.
//
import UIKit

// MARK: - TopicCell
final class TopicCell: UICollectionViewCell {
    
    // MARK: UI Elements
    private lazy var imageView: UIImageView = setupImageView()
    private lazy var nameLabel: UILabel = setupNameLabel()
    
    // MARK: Delegate
    weak var delegate: PhotoCellDelegate?
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    func configure(with topic: TopicModel) {
        imageView.image = nil
        nameLabel.text = topic.title
        
        // Loads the cover photo from the provided URL
        if let url = URL(string: topic.coverPhoto.urls.regular) {
            ImageLoader.shared.loadImage(from: url) { [weak self] image in
                guard let self = self, let image = image else { return }
                self.imageView.image = image
            }
        }
    }
}

private extension TopicCell {
    // MARK: Layout Setup
    private func setupLayout() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

// MARK: - Setup UI
private extension TopicCell {
    
    func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }
    
    func setupNameLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }
}
