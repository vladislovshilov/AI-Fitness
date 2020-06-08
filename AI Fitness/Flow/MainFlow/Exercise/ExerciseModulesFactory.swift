//
//  ExerciseModulesFactory.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import Foundation

protocol IExerciseModulesFactory {
    func makeExerciseListView() -> (view: Presentable, viewModel: IExercisesListViewModelOutput)
    func makeExerciseProcessView() -> Presentable & ExerciseProcessOutput
}

final class ExerciseModulesFactory: IExerciseModulesFactory {
    func makeExerciseListView() -> (view: Presentable, viewModel: IExercisesListViewModelOutput) {
        let viewModel = ExercisesListViewModel()
        let view = ExercisesListViewController(viewModel: viewModel)
        return (view: view, viewModel: viewModel)
    }
    
    func makeExerciseProcessView() -> Presentable & ExerciseProcessOutput {
        return ExerciseProcessViewController(screenOrientationService: ServiceLocator.shared.resolve())
    }
}
