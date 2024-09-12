//
//  SearchViewModel.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 09.09.2024.
//
import UIKit


// MARK: - SerachViewModel

final class SearchViewModel {
    
    // MARK: Dependencies
    private weak var coordinator: MainCoordinator?
    private let photoService: PhotoServiceProtocol
    
    // MARK: Variables
    private var currentPage = 1
    private let photosPerPage = 30
    private var isLoading = false
    
    // MARK: UserDefaults
    private let userDefaults = UserDefaults.standard
    
    // MARK: States
    var onDataUpdated: (() -> Void)?
    var onDefaultRequestUpdated: (() -> Void)?
    var noResultsHandler: ((Bool) -> Void)?
    var onSuggestionsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // Default search topics
    var defaultRequest: [TopicModel] = [] {
        didSet {
            onDefaultRequestUpdated?()
        }
    }
    
    // Photos fetched from the search
    var photos: [Photo] = [] {
        didSet {
            onDataUpdated?()
        }
    }
    
    // Search history stored in UserDefaults
    var searchHistory: [String] {
        get {
            userDefaults.searchHistory
        }
        set {
            userDefaults.searchHistory = newValue
        }
    }
    
    // Currently selected sorting parameter
    private var selectedSortBy: String {
        get {
            userDefaults.string(forKey: "selectedSortBy") ?? "Relevance"
        }
        set {
            userDefaults.set(newValue, forKey: "selectedSortBy")
        }
    }
    
    // Orientation filter for search results
    private var selectedOrientation: String {
        get {
            userDefaults.string(forKey: "selectedOrientation") ?? "Any"
        }
        set {
            userDefaults.set(newValue, forKey: "selectedOrientation")
        }
    }
    
    // Color filter for search results
    private var selectedColor: String {
        get {
            userDefaults.string(forKey: "selectedColor") ?? "Any"
        }
        set {
            userDefaults.set(newValue, forKey: "selectedColor")
        }
    }
    // Dependency Injection via initializer
    init(photoService: PhotoServiceProtocol = PhotoService(), coordinator: MainCoordinator) {
        self.photoService = photoService
        self.coordinator = coordinator
    }
    
    // Updates search parameters
    func updateSearchParameters(sortBy: String, orientation: String, color: String) {
        self.selectedSortBy = sortBy
        self.selectedOrientation = orientation
        self.selectedColor = color
    }
    
    // Adds new search query to the history
    func addToSearchHistory(_ query: String) {
        var history = searchHistory
        if !history.contains(query) {
            history.insert(query, at: 0)
            // Keeps only the last 5 queries in history
            if history.count > 5 {
                history.removeLast()
            }
            searchHistory = history
        }
    }
    
    // Clears search history
    //        func clearSearchHistory() {
    //            searchHistory = []
    //        }
    
    // Loads default topics for initial suggestions
    func loadTopic() {
        photoService.loadDefaultTopic() { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let topic):
                    self?.defaultRequest = topic
                    self?.onDefaultRequestUpdated?()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    
    // Loads photos based on search query with pagination support
    func loadPhotos(query: String, page: Int = 1) {
        guard !isLoading else { return }
        isLoading = true
        // Fetch photos from the photo service
        photoService.loadPhotos(query: query, page: page, perPage: photosPerPage, sortBy: selectedSortBy, orientation: selectedOrientation, color: selectedColor) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let photos):
                    // Replace or append photos depending on the page
                    if page == 1 {
                        self?.photos = photos
                    } else {
                        self?.photos.append(contentsOf: photos)
                    }
                    self?.currentPage = page
                    self?.onDataUpdated?()
                    self?.noResultsHandler?(photos.isEmpty)
                   
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    // Loads the next page of search results
    func loadNextPage(query: String) {
        loadPhotos(query: query, page: currentPage + 1)
    }
    // Displays detailed information for the selected photo
    func showDetail(for photo: Photo) {
        coordinator?.showDetail(for: photo)
    }
    // Navigates to the settings screen
    func showSetting() {
        coordinator?.showSetting()
    }
}
