//
//  SceneDelegate.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/16/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private let coordinatorFactory: ICoordinatorFactory
    private let defaultStorage: IDefaultsStorage

    var window: UIWindow?

    override init() {
        ServicesAssembly.register()
        self.coordinatorFactory = CoordinatorFactory()
        self.defaultStorage = ServiceLocator.shared.resolve()
        super.init()
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
            start()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

// MARK: - Coordinatable

extension SceneDelegate: Coordinatable {
    func start() {
        guard defaultStorage.isLogin else {
                performAuthorizationFlow()
                return
        }
        
        performMainFlow()
    }
}

// MARK: - Support methods

private extension SceneDelegate {
    func performAuthorizationFlow() {
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        let router = Router(rootController: navigationController)
        var coordinator = coordinatorFactory.makeAuthorizationCoordinator(router: router)
        coordinator.onFinishFlowHandler = {
            self.performMainFlow()
        }
        coordinator.start()
        window?.makeKeyAndVisible()
    }
    
    func performMainFlow() {
        let tabbarController = UITabBarController()
        window?.rootViewController = tabbarController
        var coordinator = coordinatorFactory.makeMainCoordinator(tabController: tabbarController)
        coordinator.onFinishFlowHandler = {
            self.performAuthorizationFlow()
        }
        coordinator.start()
        window?.makeKeyAndVisible()
    }
}

