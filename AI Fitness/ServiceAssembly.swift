//
//  ServiceAssembly.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import Foundation

final class ServicesAssembly {
    private init() { }
    
    static func register() {
        let defaults = DefaultsStorage()
        ServiceLocator.shared.register(defaults as IDefaultsStorage)
        
        let screenOrientationService = ScreenOrientationService()
        ServiceLocator.shared.register(screenOrientationService as IScreenOrientationService)
    }
}
