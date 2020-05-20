//
//  AuthModulesFactory.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import Foundation

protocol IAuthModulesFactory {
    func makeAuthView() -> Presentable & AuthViewOutput
}

final class AuthModulesFactory: IAuthModulesFactory {
    func makeAuthView() -> Presentable & AuthViewOutput {
        return AuthViewController(nibName: nil, bundle: nil)
    }
}
