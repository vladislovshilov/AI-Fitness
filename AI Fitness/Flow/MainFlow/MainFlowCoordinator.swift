//
//  MainFlowCoordinator.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import UIKit

final class MainFlowCoordinator: FinishFlowSupportable {
    private let tabBarController: UITabBarController
    private let childs: [Coordinatable]
    
    var onFinishFlowHandler: (() -> Void)?
    
    //MARK: Initialization
    required init(rootController: UITabBarController, childCoordinators: [Coordinatable]) {
        self.tabBarController = rootController
        self.childs = childCoordinators
    }
}

//MARK: Coordinatable
extension MainFlowCoordinator: Coordinatable {
    func start() {
        childs.forEach { $0.start() }
    }
}
