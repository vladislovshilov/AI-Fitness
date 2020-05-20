//
//  FirstViewController.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/16/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import UIKit

protocol ExerciseOutput {
    var onExerciseTapHandler: (() -> Void)? { get set }
}

class ExerciseController: BaseController, ExerciseOutput {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

