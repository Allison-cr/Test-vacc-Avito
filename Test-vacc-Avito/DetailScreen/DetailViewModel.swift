//
//  DetailViewModel.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 09.09.2024.
//

import Foundation

// MARK: - DetailViewModel

final class DetailViewModel {
    
    // MARK: Dependencies

    private weak var coordinator: MainCoordinator?

    // MARK: Initialiter
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
    // move back to searchViewController
    func backToMain() {
        coordinator?.popDetail()
    }
}
