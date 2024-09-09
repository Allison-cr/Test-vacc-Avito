//
//  SceneDelegate.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 09.09.2024.
//
import UIKit

protocol AppFactory {
    func makeKeyWindowWithCoordinator(scene: UIWindowScene) -> (UIWindow, Coordinator)
}

extension AppFactory {
    func makeKeyWindowWithCoordinator(
        scene: UIWindowScene
    ) -> (UIWindow, Coordinator) {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        
        let coordinator = AppCoordinator(navigationController: navigationController)
        
        let window = UIWindow(windowScene: scene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return (window, coordinator)
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        (window, coordinator) = makeKeyWindowWithCoordinator(
            scene: windowsScene
        )
        coordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

extension SceneDelegate: AppFactory {}
