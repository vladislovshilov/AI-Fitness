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
        var view = moduleFactory.makeExerciseListView()
        view.onExerciseTapHandler = {
            self.showExerciseProcessView()
        }
        
        router.setRootModule(view)
    }
    
    private func showExerciseProcessView() {
        let view = moduleFactory.makeExerciseProcessView()
        router.push(view, animated: true)
    }
}
