//
//  UserDefaults.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 12.09.2024.
//

import Foundation
import Foundation

// MARK: - UserDefaults

extension UserDefaults {
    private enum Keys {
        static let searchHistory = "searchHistory"
    }
    // storage history search 
    var searchHistory: [String] {
        get {
            return (array(forKey: Keys.searchHistory) as? [String]) ?? []
        }
        set {
            set(newValue, forKey: Keys.searchHistory)
        }
    }
}
