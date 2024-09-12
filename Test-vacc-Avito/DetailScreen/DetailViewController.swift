//
//  DetailViewController.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 09.09.2024.
//

import UIKit

// MARK: - DetailViewController

final class DetailViewController: UIViewController {
    
    // MARK: UI Elements

    private lazy var backButton: UIButton = setupBackButton()
    private lazy var photoImageView: UIImageView = setupPhotoImageView()
    private lazy var descriptionLabel: UILabel = setupDescriptionLabel()
    private lazy var likesLabel: UILabel = setupLikesLabel()
    private lazy var nameLabel: UILabel = setupNameLabel()
    private lazy var userNameLabel: UILabel = setupUserNameLabel()
    private lazy var likesButton: UIButton = setupLikesButton()
    private lazy var saveButton: UIButton = setupSaveButton()
    private lazy var sendButton: UIButton = setupSendButton()
    private lazy var scrollView: UIScrollView = setupScrollView()
    private lazy var stackView: UIStackView = setupStackView()
    // for anime loading stub view 
    private var stubImageView = DetailStubView()
    
    // MARK: Depency

    private let photo: Photo
    private let viewModel: DetailViewModel
    
    // MARK: - Initializers

    init(photo: Photo, viewModel: DetailViewModel) {
        self.photo = photo
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .settingBackgraound
        stubImageView.translatesAutoresizingMaskIntoConstraints = false
        setupNavigationBar()
        setupStub()
        updateUI()
    }
    
    func updateUI() {
        if let url = URL(string: photo.urls.full) {
            ImageLoader.shared.loadImage(from: url) { [weak self] image in
                DispatchQueue.main.async {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self?.stubImageView.removeFromSuperview()
                    self?.setupMainLayout()
                    self?.photoImageView.image = image
                        if let image = self?.photoImageView.image {
                            let aspectRatio = image.size.height / image.size.width
                            self?.photoImageView.heightAnchor.constraint(equalTo: (self?.photoImageView.widthAnchor)!, multiplier: aspectRatio).isActive = true
                        }
                    }
                }
            }
        }
    }
}

// MARK: - obj action methods
private extension DetailViewController {
    
    // return back to search
    @objc private func backButtonTapped() {
        photoImageView.stopAnimating()
           viewModel.backToMain()
       }
    
    // like button
    @objc private func liked() {
       //
    }
    
    // send image to contacts
    @objc private func sendImage() {
        guard let image = photoImageView.image else {
            print("Image not found")
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }

    // handler
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                print("Error saving image: \(error.localizedDescription)")
            } else {
                print("Image saved successfully!")
            }
        }
    
    // confirm save sheet
    @objc func showSaveActionSheet() {
        let actionSheet = UIAlertController(title: "Would you like to add?", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            guard let image = self.photoImageView.image else {
                print("Image not found")
                return
            }
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
}


// MARK: - Setup UI

private extension DetailViewController {
    
    func setupUserNameLabel() -> UILabel {
        let label = UILabel()
        label.text = photo.user.username
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func setupNameLabel() -> UILabel {
        let label = UILabel()
        label.text = photo.user.name
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
    
    func setupLikesLabel() -> UILabel {
        let label = UILabel()
        label.text = "\(photo.likes)"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
    
    func setupDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.text = photo.alt_description
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setupPhotoImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    func setupBackButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        view.addSubview(button)
        return button
    }
    
    func setupLikesButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .black
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.addTarget(self, action: #selector(liked), for: .touchUpInside)
        button.layer.cornerRadius = 48 / 2
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }
    
    func setupSaveButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .black
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 48 / 2
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.addTarget(self, action: #selector(showSaveActionSheet), for: .touchUpInside)
        view.addSubview(button)
        return button
    }
    
    func setupSendButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up.square"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(sendImage), for: .touchUpInside)
        view.addSubview(button)
        return button
    }
    
    func setupScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 128, right: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        return scrollView
    }
    
    func setupStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.backgroundColor = .settingBackgraound
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(photoImageView)
        stackView.addArrangedSubview(userNameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        return stackView
    }
}

// MARK: Setup Layout

private extension DetailViewController {
    func setupNavigationBar() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.heightAnchor.constraint(equalToConstant: 48),
            backButton.widthAnchor.constraint(equalToConstant: 48),
     
            sendButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            sendButton.heightAnchor.constraint(equalToConstant: 48),
            sendButton.widthAnchor.constraint(equalToConstant: 48),
     
        ])
        
    }
    func setupMainLayout() {
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            nameLabel.heightAnchor.constraint(equalToConstant: 48),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            scrollView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
              
            likesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            likesButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -32),
            likesButton.heightAnchor.constraint(equalToConstant: 48),
            likesButton.widthAnchor.constraint(equalToConstant: 48),
            
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            saveButton.heightAnchor.constraint(equalToConstant: 48),
            saveButton.widthAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    // for animate loading
    func setupStub() {
        view.addSubview(stubImageView)
        NSLayoutConstraint.activate([
            stubImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stubImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stubImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 32),
            stubImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
