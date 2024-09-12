//
//  SearchModel.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 09.09.2024.
//

import Foundation

struct SearchResults: Codable {
    let results: [Photo]
}

struct Photo: Codable {
    let id: String
    let description: String?
    let alt_description: String?
    let urls: PhotoURLs
    let likes: Int
    let user: User
}

struct PhotoURLs: Codable {
    let small: String
    let regular: String
    let full: String
}

struct User: Codable {
    let name: String
    let username: String
}
