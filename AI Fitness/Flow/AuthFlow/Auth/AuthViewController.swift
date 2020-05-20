//
//  AuthViewController.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import UIKit

protocol AuthViewOutput {
    var onContinueHandler: ((String?) -> Void)? { get set }
}

class AuthViewController: BaseController, AuthViewOutput {
    
    @IBOutlet private weak var nameTextField: UITextField!
    
    var onContinueHandler: ((String?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func continueButtonDidPress(_ sender: Any) {
        onContinueHandler?(nameTextField.text)
    }
}
