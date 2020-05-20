//
//  ExerciseModulesFactory.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import Foundation

protocol IExerciseModulesFactory {
    func makeExerciseListView() -> Presentable & ExercisesListOutput
    func makeExerciseProcessView() -> Presentable
}

final class ExerciseModulesFactory: IExerciseModulesFactory {
    func makeExerciseListView() -> Presentable & ExercisesListOutput {
        return ExercisesListViewController(nibName: nil, bundle: nil)
    }
    
    func makeExerciseProcessView() -> Presentable {
        return ExerciseProcessViewController(nibName: nil, bundle: nil)
    }
}
