//
//  BaseCoordinator.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 09.09.2024.
//

import Foundation

// MARK: - Coordinator Protocol

/// The `Coordinator` protocol defines a blueprint for coordinators, which are responsible for managing the navigation flow within the application.
protocol Coordinator: AnyObject {
    /// Starts the coordinator's work. Should be overridden in subclasses to define specific behavior.
    func start()
}

// MARK: - BaseCoordinator

class BaseCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var childCoordinator: [Coordinator] = []
    
    // MARK: - Coordinator Lifecycle
    
    /// Starts the coordinator's work. This method should be overridden by subclasses to define specific startup behavior.
    func start() {
        // To be implemented by subclasses
    }
    
    // MARK: - Child Coordinator Management
       
    /// Adds a child coordinator to the list of managed coordinators.
    /// - Parameter coordinator: The child coordinator to add.
    func addChild(_ coordinator: Coordinator) {
        guard !childCoordinator.contains(where: { $0 === coordinator }) else { return }
        childCoordinator.append(coordinator)
    }
     
    /// Removes a child coordinator from the list of managed coordinators.
    /// This method will also recursively remove any child coordinators managed by the coordinator being removed.
    /// - Parameter coordinator: The child coordinator to remove.
    func removeChild(_ coordinator: Coordinator) {
        guard !childCoordinator.isEmpty else { return }
        // Recursively remove all child coordinators
        if let coordinator = coordinator as? BaseCoordinator, !coordinator.childCoordinator.isEmpty {
            coordinator.childCoordinator.forEach { coordinator.removeChild($0) }
        }
        // Remove the specified coordinator
        if let index = childCoordinator.firstIndex(where: { $0 === coordinator }) {
            childCoordinator.remove(at: index)
        }
    }
}
