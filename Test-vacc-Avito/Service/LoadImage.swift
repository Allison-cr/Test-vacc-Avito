//
//  LoadImage.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 09.09.2024.
//

import Foundation

// MARK: -
//Application ID
//651960
//
//Access Key
//STQjdJn0RcZyowlkB_6CdzKLqN1KCjWC_24L3_nuF4Q
//
//Secret key
//sjY7cWw-WKiaa6iBGqIQo6eVo-oLagRuG4kPNrfkgws
// MARK: -


import Foundation

class LoadImage {
    
    func loadImage() {
        let accessKey = "STQjdJn0RcZyowlkB_6CdzKLqN1KCjWC_24L3_nuF4Q"
        let query = "nature"
        let url = URL(string: "https://api.unsplash.com/search/photos?query=\(query)&client_id=\(accessKey)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error:", error ?? "Unknown error")
                return
            }
            // Обработка ответа
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                print(json)
            }
        }
        task.resume()
    }
}
