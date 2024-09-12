//
//  MainCoordinator.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 09.09.2024.
//
import Foundation
import UIKit

// MARK: - MainCoordinator

final class MainCoordinator: Coordinator {
    
    // MARK: - Properties
       
    private let navigationController: UINavigationController
    
    // MARK: - Initializer
     
    /// Initializes the `MainCoordinator` with a specified navigation controller.
    /// - Parameter navigationController: The navigation controller used to manage view controllers in the main flow.
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Lifecycle
     
    /// Starts the main flow by calling the `runMainFlow()` method.
    func start() {
        runMainFlow()
    }
    
    // MARK: - Private Methods
     
    /// Configures and starts the main flow of the application.
    /// This method sets up the `MainViewModel` and `MainViewController`, and pushes the main view onto the navigation stack.
    func runMainFlow() {
        let viewModel = SearchViewModel(coordinator: self)
        let mainViewController = SearchViewController(viewModel: viewModel)
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    // MARK: Show Detail View
    
    func showDetail(for photo: Photo) {
        let detailViewModel = DetailViewModel(coordinator: self)
        let detailViewController = DetailViewController(photo: photo, viewModel: detailViewModel)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: Back to SearchViewController
    
    func popDetail() {
        navigationController.popViewController(animated: true)
    }
    
    // MARK: Show Setting View

    func showSetting() {
        let viewController = SettingViewController()
        viewController.modalPresentationStyle = .pageSheet 
        navigationController.present(viewController, animated: true, completion: nil)
    }
}
