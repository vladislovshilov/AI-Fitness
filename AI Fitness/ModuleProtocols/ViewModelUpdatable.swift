//
//  ViewModelUpdateble.swift
//  AI Fitness
//
//  Created by Vlados iOS on 6/8/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import Foundation

protocol ViewModelUpdatable: class {
    associatedtype ViewModel
    var viewModel: ViewModel { get }
    func updateView(with viewModel: ViewModel)
}
