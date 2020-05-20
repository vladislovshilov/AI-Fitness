//
//  AppFlowCoordinator.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import UIKit

final class AppFlowCoordinator {
    private let window: UIWindow
    private let coordinatorFactory: ICoordinatorFactory
    private let defaultStorage: IDefaultsStorage
    
    required init(window: UIWindow,
                  coordinatorFactory: ICoordinatorFactory) {
        ServicesAssembly.register()
        
        self.window = window
        self.coordinatorFactory = coordinatorFactory
        self.defaultStorage = ServiceLocator.shared.resolve()
    }
}

// MARK: - Coordinatable

extension AppFlowCoordinator: Coordinatable {
    func start() {
        guard defaultStorage.isLogin else {
                performAuthorizationFlow()
                return
        }
        
        performMainFlow()
    }
}

// MARK: - Support methods

private extension AppFlowCoordinator {
    func performAuthorizationFlow() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        let router = Router(rootController: navigationController)
        var coordinator = coordinatorFactory.makeAuthorizationCoordinator(router: router)
        coordinator.onFinishFlowHandler = {
            self.performMainFlow()
        }
        coordinator.start()
        window.makeKeyAndVisible()
    }
    
    func performMainFlow() {
        let tabbarController = UITabBarController()
        window.rootViewController = tabbarController
        var coordinator = coordinatorFactory.makeMainCoordinator(tabController: tabbarController)
        coordinator.onFinishFlowHandler = {
            self.performAuthorizationFlow()
        }
        coordinator.start()
        window.makeKeyAndVisible()
    }
}

