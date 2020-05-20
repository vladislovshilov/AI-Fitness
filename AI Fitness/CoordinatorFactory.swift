//
//  CoordinatorFactory.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import UIKit

protocol ICoordinatorFactory {
    func makeAuthorizationCoordinator(router: Routable) -> Coordinatable & FinishFlowSupportable
    func makeMainCoordinator(tabController: UITabBarController) -> Coordinatable & FinishFlowSupportable
}

private typealias ChildCoordinator = (coordinator: Coordinatable & TabBarItemSupportable,
                                      navigation: UINavigationController)

final class CoordinatorFactory: ICoordinatorFactory {
    func makeAuthorizationCoordinator(router: Routable) -> Coordinatable & FinishFlowSupportable {
        let moduleFactory = AuthModulesFactory()
        return AuthorizationCoordinator(factory: moduleFactory, router: router)
    }
    
    func makeMainCoordinator(tabController: UITabBarController) -> Coordinatable & FinishFlowSupportable {
        let exercises = makeExercisesCoordinator()
        let profile = makeProfileCoordinator()

        tabController.viewControllers = [exercises.navigation,
                                         profile.navigation]
        
        let childs = [exercises.coordinator,
                      profile.coordinator]
        let mainFlowCoordinator = MainFlowCoordinator(rootController: tabController,
                                                      childCoordinators: childs)
        return mainFlowCoordinator
    }
    
    private func makeExercisesCoordinator() -> ChildCoordinator {
        let exerciseModuleFactory = ExerciseModulesFactory()
        
        let navigation = UINavigationController()
        let router = Router(rootController: navigation)
        let cooridnator = ExerciseCoordinator(factory: exerciseModuleFactory,
                                              router: router)
        navigation.tabBarItem = cooridnator.item
        return (cooridnator, navigation)
    }
    
    private func makeProfileCoordinator() -> ChildCoordinator {
        let navigation = UINavigationController()
        let router = Router(rootController: navigation)
        let cooridnator = ProfileCoordinator(router: router)
        navigation.tabBarItem = cooridnator.item
        return (cooridnator, navigation)
    }
}
