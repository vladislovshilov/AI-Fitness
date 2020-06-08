//
//  ExerciseListViewModel.swift
//  AI Fitness
//
//  Created by Vlados iOS on 6/8/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import Foundation

struct Exercise {
    var name: String
    var description: String
}

protocol IExercisesListViewModel {
    var title: String { get }
    var exercisesCount: Int { get }
    
    func exerciseForIndex(_ index: Int) -> Exercise
    func showExerciseDescriptionScreen(forIndex index: Int)
}

protocol IExercisesListViewModelOutput {
    var onExerciseSelectHandler: ((Exercise) -> Void)? { get set }
}

class ExercisesListViewModel: IExercisesListViewModel, IExercisesListViewModelOutput {
    
    // MARK: - Handler's
    
    var onExerciseSelectHandler: ((Exercise) -> Void)?
    
    // MARK: Properties
    
    var title = "Exercises"
    var exercisesCount = 6
    
    // MARK: Public methods
    
    func exerciseForIndex(_ index: Int) -> Exercise {
        return Exercise(name: "\(index)", description: "")
    }
    
    func showExerciseDescriptionScreen(forIndex index: Int) {
        onExerciseSelectHandler?(Exercise(name: "\(index)", description: ""))
    }
}
