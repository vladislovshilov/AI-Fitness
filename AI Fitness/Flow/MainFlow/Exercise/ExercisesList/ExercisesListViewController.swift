//
//  ExerciseViewController.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import UIKit

protocol ExercisesListOutput {
    var onExerciseTapHandler: (() -> Void)? { get set }
}

class ExercisesListViewController: BaseController, ExercisesListOutput {
    
    var onExerciseTapHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func startButtonDidPress(_ sender: Any) {
        onExerciseTapHandler?()
    }
    
}
