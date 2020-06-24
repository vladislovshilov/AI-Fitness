//
//  ExerciseResultViewController.swift
//  AI Fitness
//
//  Created by Vlados iOS on 6/24/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import UIKit
import UICircularProgressRing

class ExerciseResultViewController: UIViewController {
    
    @IBOutlet weak var resultProgressRing: UICircularProgressRing!
    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    var accuracyValue = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.alpha = 0
        congratsLabel.alpha = 0.1
        resultProgressRing.font = UIFont.boldSystemFont(ofSize: 42)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultProgressRing.startProgress(to: 0, duration: 1) {
            self.resultProgressRing.animateProperties(duration: 1) {
                self.resultProgressRing.value = CGFloat(self.accuracyValue)
                self.continueButton.alpha = 1
            }
        }
        UIView.animate(withDuration: 2) {
            self.congratsLabel.alpha = 1
        }
    }
    
}
