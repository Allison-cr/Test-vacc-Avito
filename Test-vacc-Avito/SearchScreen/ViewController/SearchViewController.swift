//
//  SearchViewController.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 09.09.2024.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func didUpdateSearchParameters(_ parameters: SearchParameters)
}

// MARK: - SearchViewController

final class SearchViewController: UIViewController {
    
    // MARK: UI Elements

    private lazy var searchBar: UISearchBar = setupSearchBar()
    private lazy var collectionView: UICollectionView = setupCollectionView()
    private lazy var settingButton: UIButton = setupSettingButton()
    private lazy var defaultCollectionView: UICollectionView = setupDefaultCollectionView()
    private lazy var defaultLabel: UILabel = setupDefaultLabel()
    private lazy var searchLabel: UILabel = setupSearchLabel()
    private lazy var closeButton: UIButton = setupCloseButton()
    private lazy var partialModalView: PartialModalView = setupPartialModalView()
    private lazy var emptyImageView: UIImageView = setupEmptyImageView()
    
    // MARK: Variables
    private var searchBarTrailingConstraint: NSLayoutConstraint?
    
    // MARK: Depency
    
    private let viewModel: SearchViewModel

    // MARK: - Initializers

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        view.backgroundColor = .settingBackgraound
        viewModel.loadTopic()
        setupLayout()
        setupBindings()
        viewModel.loadPhotos(query: "Ar")
    }
}

// MARK: - Setup UI

extension SearchViewController {
    private func setupPartialModalView() -> PartialModalView {
        let customView = PartialModalView()
        customView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        customView.layer.cornerRadius = 16
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.backgroundColor = .settingBackgraound
        customView.delegate = self
        view.addSubview(customView)
        customView.isHidden = true
        return customView
    }
    
    private func setupCloseButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(button)
        return button
    }
    
    private func setupDefaultLabel() -> UILabel {
        let label = UILabel()
        label.text = "Browse by category"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
    
    private func setupSearchLabel() -> UILabel {
        let label = UILabel()
        label.text = "Search"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
    
    private func setupSettingButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(pushSetting), for: .touchUpInside)
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        view.addSubview(button)
        return button
    }
    
    private func setupEmptyImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .empty)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        view.addSubview(imageView)
        return imageView
    }

    private func setupSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        searchBar.searchTextField.textColor = .white
        searchBar.backgroundColor = .settingBackgraound
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Введите запрос"
        return searchBar
    }
    
    private func setupCollectionView() -> UICollectionView {
        let layout = MasonryLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .settingBackgraound
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        view.addSubview(collectionView)
        return collectionView
    }
    
    private func setupDefaultCollectionView() -> UICollectionView {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .absolute(256))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item,item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TopicCell.self, forCellWithReuseIdentifier: "TopicCell")
        collectionView.backgroundColor = Colors.settingBackgroundColor
        view.addSubview(collectionView)
        return collectionView
    }
}



// MARK: Conection state viewModel - View

extension SearchViewController: SettingViewControllerDelegate {
    
    private func setupBindings() {
        // State for uptade collectionView after request
        viewModel.onDataUpdated = { [weak self] in
            self?.collectionView.reloadData()
        }
        // State for uptade defaultCollectionView after request
        viewModel.onDefaultRequestUpdated = { [weak self] in
            self?.defaultCollectionView.reloadData()
        }
        // State for emptry reqeuest
        viewModel.noResultsHandler = { [weak self] isEmpty in
            self?.noResultsHandler(isEmpty)
        }
        // State for hints when entering text into search
        viewModel.onSuggestionsUpdated = { [weak self] in
            self?.partialModalView.updateData()
        }
    }
    
    // Uptade parametres for search (setting)
    func didUpdateSearchParameters(_ parameters: SearchParameters) {
        viewModel.updateSearchParameters(
            sortBy: parameters.sortBy,
            orientation: parameters.orientation,
            color: parameters.color
        )
        if let query = searchBar.text, !query.isEmpty {
            viewModel.loadPhotos(query: query)
        }
    }
    
    func noResultsHandler(_ isEmpty: Bool) {
        if !isEmpty {
            emptyImageView.isHidden = true
        }
        else {
            emptyImageView.isHidden = false
        }
    }
}

// MARK: - Setup Layout

private extension SearchViewController {
    
    func setupLayout() {
        // custom move closeButton
        searchBarTrailingConstraint = searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        searchBarTrailingConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.heightAnchor.constraint(equalToConstant: 64),
            
            defaultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            defaultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            defaultLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            
            defaultCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            defaultCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            defaultCollectionView.topAnchor.constraint(equalTo: defaultLabel.bottomAnchor, constant: 8),
            defaultCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            searchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchLabel.topAnchor.constraint(equalTo: defaultCollectionView.bottomAnchor, constant: 8),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            
            settingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            settingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            settingButton.heightAnchor.constraint(equalToConstant: 48),
            settingButton.widthAnchor.constraint(equalToConstant: 48),
            
            closeButton.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: -8),
            closeButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 8),
            closeButton.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
           
            partialModalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            partialModalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            partialModalView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            partialModalView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        ])
    }
    
    private func updateConstraintsForSearch() {
        NSLayoutConstraint.deactivate([
            defaultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            defaultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            defaultLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            
            defaultCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            defaultCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            defaultCollectionView.topAnchor.constraint(equalTo: defaultLabel.bottomAnchor, constant: 8),
            defaultCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            searchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchLabel.topAnchor.constraint(equalTo: defaultCollectionView.bottomAnchor, constant: 8),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
 
        ])
        NSLayoutConstraint.activate([
     
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            
            settingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            settingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            settingButton.heightAnchor.constraint(equalToConstant: 48),
            settingButton.widthAnchor.constraint(equalToConstant: 48),
            
            closeButton.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: -8),
            closeButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 8),
            closeButton.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
           
            partialModalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            partialModalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            partialModalView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            partialModalView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            
            emptyImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyImageView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
        ])
        
        UIView.animate(withDuration: 0.3, animations: {
              self.view.layoutIfNeeded()
          })
    }

    
    // custom move closeButton
    private func updateSearchBar() {
        searchBarTrailingConstraint?.constant = -8 - closeButton.frame.width
     
           UIView.animate(withDuration: 0.3) {
               self.view.layoutIfNeeded()
           }
       }
    
    private func updateSearchBarBack() {
        searchBarTrailingConstraint?.constant = -8
           
           UIView.animate(withDuration: 0.3) {
               self.view.layoutIfNeeded()
           }
       }
    
}

// MARK: - obj action methods

extension SearchViewController {
    
    // Push settingView
    @objc private func pushSetting() {
        let settingsVC = SettingViewController()
        settingsVC.delegate = self
        present(settingsVC, animated: true, completion: nil)
    }
    
    // Tap closeButton
    @objc private func closeButtonTapped() {
        searchBar.resignFirstResponder()
        closeButton.isHidden = true
        dismissCustomView()
        updateSearchBarBack()
    }
    
    // hide partialModalView
    @objc private func dismissCustomView() {
        partialModalView.isHidden = true
    }
    
    // show partialModalView
    @objc private func showCustomView() {
        partialModalView.isHidden = false
        partialModalView.updateData()
    }
}

// MARK: - SearchBar Methdods

extension SearchViewController: UISearchBarDelegate {
    
    func requestSearch() {
        searchBar.resignFirstResponder()
        closeButtonTapped()
        updateConstraintsForSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.loadPhotos(query: query)
        viewModel.addToSearchHistory(query)
        requestSearch()
        print(query)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        partialModalView.filterHistory(with: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showCustomView()
        updateSearchBar()
        closeButton.isHidden = false
        emptyImageView.isHidden = true
    }
}

// MARK: - UICollectionView Methods

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.defaultCollectionView {
            return viewModel.defaultRequest.count
        } else {
            return viewModel.photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.defaultCollectionView {
            let topic = viewModel.defaultRequest[indexPath.item]
            viewModel.loadPhotos(query: topic.title)
            requestSearch()
        } else {
            let selectedPhoto = viewModel.photos[indexPath.item]
            viewModel.showDetail(for: selectedPhoto)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.defaultCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCell", for: indexPath) as! TopicCell
            let topic = viewModel.defaultRequest[indexPath.item]
            cell.configure(with: topic)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
            let photo = viewModel.photos[indexPath.row]
            cell.delegate = self
            cell.configure(with: photo)
            return cell
        }
    }
}

// MARK: - Delagate PhotoCell

extension SearchViewController: PhotoCellDelegate {
    func photoCell(_ cell: PhotoCell, didUpdateSize size: CGSize) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        if let layout = collectionView.collectionViewLayout as? MasonryLayout {
            layout.updateCellSize(for: indexPath, size: size)
        }
    }
}

extension SearchViewController: PartialModalViewDelegate {
    func partialModalView(_ view: PartialModalView, didSelectQuery query: String) {
        viewModel.loadPhotos(query: query)
        searchBar.text = query
        viewModel.addToSearchHistory(query)
        requestSearch()
    }
}

// MARK: - Pagination

extension SearchViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if contentHeight - contentOffsetY < scrollViewHeight {
            let query = searchBar.text ?? ""
            viewModel.loadNextPage(query: query)
        }
    }
}


