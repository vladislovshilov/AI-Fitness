//
//  ExerciseCoordinator.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import UIKit

final class ExerciseCoordinator {
    private let moduleFactory: IExerciseModulesFactory
    private let router: Routable
    
    //MARK: Initialization
    required init(factory: IExerciseModulesFactory,
                  router: Routable) {
        self.moduleFactory = factory
        self.router = router
    }
}

extension ExerciseCoordinator: TabBarItemSupportable {
    var image: UIImage? {
        return R.image.exerciseIcon()
    }
    
    var selectedImage: UIImage? {
        return R.image.exerciseIconFill()
    }
    
    var title: String {
        return "Exercises"
    }
}

extension ExerciseCoordinator: Coordinatable {
    func start() {
        var module = moduleFactory.makeExerciseListView()
        module.viewModel.onExerciseSelectHandler = { exercise in
            self.showExerciseProcessView()
        }
        
        router.setRootModule(module.view)
    }
    
    private func showExerciseProcessView() {
        var view = moduleFactory.makeExerciseProcessView()
        view.onFinishHandler = {
            self.router.dismissModule(animated: true)
        }
        view.onCancelHandler = {
            self.router.dismissModule(animated: true)
        }
        
        router.present(view, animated: true)
    }
}
