//
//  Routable.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import Foundation

protocol Routable: Presentable {
    func present(_ module: Presentable?, animated: Bool)
    func presentModuleWithNavigation(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool)
    func popModule(animated: Bool)
    func dismissModule(animated: Bool)
    func setRootModule(_ module: Presentable?)
    func popToRootModule(animated: Bool)
}

