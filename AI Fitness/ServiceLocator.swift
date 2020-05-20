//
//  ServiceLocator.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import Foundation

final class ServiceLocator {
    static let shared = ServiceLocator()
    private lazy var services = [ObjectIdentifier: Any]()
    
    private init() {}
    
    func register<T>(_ service: T) {
        services[ObjectIdentifier(T.self)] = service
    }
    
    func resolve<T>() -> T {
        guard let service = services[ObjectIdentifier(T.self)] as? T else {
            fatalError("ServiceLocator. try to get unregisterd service")
        }
        return service
    }
}
