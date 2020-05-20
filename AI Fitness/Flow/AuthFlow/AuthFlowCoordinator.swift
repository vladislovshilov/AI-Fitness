//
//  AuthFlowCoordinator.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import Foundation

final class AuthorizationCoordinator: FinishFlowSupportable {
    private var defaultStorage: IDefaultsStorage
    private let moduleFactory: IAuthModulesFactory
    private let router: Routable
    
    var onFinishFlowHandler: (() -> Void)?
    
    //MARK: Initialization
    required init(factory: IAuthModulesFactory,
                  router: Routable) {
        self.defaultStorage = ServiceLocator.shared.resolve()
        self.moduleFactory = factory
        self.router = router
    }
}

//MARK: Coordinatable
extension AuthorizationCoordinator: Coordinatable {
    func start() {
        var authView = moduleFactory.makeAuthView()
        authView.onContinueHandler = { name in
            self.defaultStorage.name = name ?? "%username"
            self.onFinishFlowHandler?()
        }
        
        router.setRootModule(authView)
    }
}
