//
//  LoadImage.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 09.09.2024.
//

import Foundation

//Application ID
//651960
//
//Access Key
//STQjdJn0RcZyowlkB_6CdzKLqN1KCjWC_24L3_nuF4Q
//
//Secret key
//sjY7cWw-WKiaa6iBGqIQo6eVo-oLagRuG4kPNrfkgws

// MARK: - PhotoServiceProtocol

protocol PhotoServiceProtocol {
    func loadPhotos(query: String, page: Int, perPage: Int, sortBy: String, orientation: String, color: String, completion: @escaping (Result<[Photo], Error>) -> Void)
    func loadDefaultTopic(completion: @escaping (Result<[TopicModel], Error>) -> Void)
}

// MARK: - PhotoService

final class PhotoService: PhotoServiceProtocol {
    private let accessKey = "STQjdJn0RcZyowlkB_6CdzKLqN1KCjWC_24L3_nuF4Q"

    // MARK: - Load Photos
    func loadPhotos(query: String, page: Int, perPage: Int, sortBy: String, orientation: String, color: String, completion: @escaping (Result<[Photo], Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://api.unsplash.com/search/photos")
        urlComponents?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "client_id", value: accessKey)
        ]
        
        if let orderByValue = convertSortByToAPIValue(sortBy) {
            urlComponents?.queryItems?.append(URLQueryItem(name: "order_by", value: orderByValue))
        }
        
        if let orientationValue = convertOrientationToAPIValue(orientation) {
            urlComponents?.queryItems?.append(URLQueryItem(name: "orientation", value: orientationValue))
        }
        
        if let colorValue = convertColorToAPIValue(color) {
            urlComponents?.queryItems?.append(URLQueryItem(name: "color", value: colorValue))
        }
        
        
        guard let url = urlComponents?.url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let searchResults = try JSONDecoder().decode(SearchResults.self, from: data)
                completion(.success(searchResults.results))
              
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - Helper Methods
    
    private func convertSortByToAPIValue(_ sortBy: String) -> String? {
        switch sortBy {
        case "Relevance":
            return "relevant"
        case "Newest":
            return "latest"
        default:
            return nil
        }
    }
    
    private func convertOrientationToAPIValue(_ orientation: String) -> String? {
        switch orientation {
        case "Portrait":
            return "portrait"
        case "Landscape":
            return "landscape"
        case "Square":
            return "squarish"
        default:
            return nil
        }
    }

    private func convertColorToAPIValue(_ color: String) -> String? {
        switch color {
        case "BlackAndWhite":
            return "black_and_white"
        case "Black":
            return "black"
        case "White":
            return "white"
        case "Yellow":
            return "yellow"
        case "Orange":
            return "orange"
        case "Red":
            return "red"
        case "Purple":
            return "purple"
        case "Magenta":
            return "magenta"
        case "Green":
            return "green"
        case "Teal":
            return "teal"
        case "Blue":
            return "blue"
        default:
            return nil
        }
    }
    
    // MARK: - Load Default Topics
    
    func loadDefaultTopic(completion: @escaping (Result<[TopicModel], Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://api.unsplash.com/topics")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey)
        ]
        
        guard let url = urlComponents?.url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            let decoder = JSONDecoder()
           
            do {
                let topics = try decoder.decode([TopicModel].self, from: data) 
                completion(.success(topics))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

}

