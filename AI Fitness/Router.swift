//
//  Router.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import UIKit

final class Router: NSObject, Routable {
    
    fileprivate weak var rootController: UINavigationController?
    
    var toPresent: UIViewController? {
        return rootController
    }
    
    //MARK: Initialization
    required init(rootController: UINavigationController) {
        self.rootController = rootController
    }
    
    //MARK: Routable
    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent else { return }
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    func presentModuleWithNavigation(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent else { return }
        let navigation = UINavigationController(rootViewController: controller)
        rootController?.present(navigation, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool) {
        guard
            let controller = module?.toPresent,
            !(controller is UINavigationController)
            else { assertionFailure("⚠️Deprecated push UINavigationController."); return }
        rootController?.pushViewController(controller, animated: animated)
    }
    
    func popModule(animated: Bool)  {
        rootController?.popViewController(animated: animated)
    }
    
    
    func dismissModule(animated: Bool) {
        rootController?.dismiss(animated: animated, completion:  nil)
    }
    
    func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        guard let controller = module?.toPresent else { return }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
    }
    
    func popToRootModule(animated: Bool) {
        rootController?.popViewController(animated: animated)
    }
}
