//
//  SearchViewController.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 09.09.2024.
//

import Foundation
import UIKit

protocol ProtocolSearchViewController: AnyObject {
    
}

final class SearchViewController: UIViewController, ProtocolSearchViewController {
    private let viewModel: SearchViewModel
    
    /// Initializer
    /// - Parameters:
    ///   - viewModel: The view model to initialize with.
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        LoadImage().loadImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
