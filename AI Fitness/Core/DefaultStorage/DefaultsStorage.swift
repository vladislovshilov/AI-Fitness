//
//  DefaultsStorage.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import Foundation

protocol IDefaultsStorage {
    var isLogin: Bool { get set }
    var name: String { get set }
}

final class DefaultsStorage: IDefaultsStorage {
    private let defaults = UserDefaults.standard
    private enum Keys: String {
        case isLogin = "aifitness.DefaultsStorage.isLogin"
        case name = "aifitness.DefaultsStorage.name"
    }
    
    var isLogin: Bool {
        get {
            guard let value = defaults.value(forKey: Keys.isLogin.rawValue) as? Bool else {
                return false
            }
            return value
        }
        set {
            defaults.set(newValue, forKey: Keys.isLogin.rawValue)
        }
    }
    
    var name: String {
        get {
            guard let value = defaults.value(forKey: Keys.name.rawValue) as? String else {
                return "%username"
            }
            return value
        }
        set {
            defaults.set(newValue, forKey: Keys.name.rawValue)
        }
    }
}
