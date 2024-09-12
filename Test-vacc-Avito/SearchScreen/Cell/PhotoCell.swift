//
//  PhotoCell.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 09.09.2024.
//
//
//  PhotoCell.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 09.09.2024.
//
import UIKit

// MARK: - PhotoCellDelegate Protocol
protocol PhotoCellDelegate: AnyObject {
    // Notifies delegate when the cell's size has been updated
    func photoCell(_ cell: PhotoCell, didUpdateSize size: CGSize)
}

// MARK: - PhotoCell
final class PhotoCell: UICollectionViewCell {
    
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
    func configure(with photo: Photo) {
        imageView.image = nil
        nameLabel.text = photo.user.name
        
        // Loads image from URL and updates the cell's size
        if let url = URL(string: photo.urls.small) {
            ImageLoader.shared.loadImage(from: url) { [weak self] image in
                guard let self = self, let image = image else { return }
                self.imageView.image = image
                let size = image.size
                self.delegate?.photoCell(self, didUpdateSize: size)
            }
        }
    }
}

private extension PhotoCell {
    // MARK: Layout Setup
    func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}

// MARK: - Setup UI
private extension PhotoCell {
    
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
