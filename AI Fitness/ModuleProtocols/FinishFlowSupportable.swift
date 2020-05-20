//
//  FinishFlowSupportable.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import Foundation

protocol FinishFlowSupportable {
    var onFinishFlowHandler: (() -> Void)? { get set }
}
