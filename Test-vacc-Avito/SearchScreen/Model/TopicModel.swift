//
//  Model.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 11.09.2024.
//

import Foundation
import Foundation

struct TopicModel: Codable {
    let title: String
    let coverPhoto: CoverPhoto
    
    enum CodingKeys: String, CodingKey {
        case title
        case coverPhoto = "cover_photo"
    }
}

struct CoverPhoto: Codable {
    let id: String
    let urls: PhotoUrls
}

struct PhotoUrls: Codable {
    let regular: String
}
