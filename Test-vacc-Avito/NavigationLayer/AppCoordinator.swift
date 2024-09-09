//
//  AppCoordinator.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 09.09.2024.
//
import UIKit

// MARK: - AppCoordinator

final class AppCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    /// The main navigation controller used to manage view controllers.
      private let navigationController: UINavigationController

    // MARK: - Initializer
    
    /// Initializes the `AppCoordinator` with a specified navigation controller.
    /// - Parameter navigationController: The navigation controller that will manage the app's navigation stack.
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
     
    // MARK: - Coordinator Lifecycle
    /// Starts the coordinator by initiating the main navigation flow of the application.
    override func start() {
        runMainFlow()
    }
    
    // MARK: - Private Methods
    
    /// Configures and starts the main flow of the application.
    /// This typically involves creating the primary view controllers and presenting them
    private func runMainFlow() {
        let coordinator = MainCoordinator(navigationController: navigationController)
        addChild(coordinator)
        coordinator.start()
    }
}
