//
//  ScreenOrientationService.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/22/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import UIKit

protocol IScreenOrientationService {
    func changeLockedInterfaceOrientation(_ orientation: UIInterfaceOrientationMask)
}

class ScreenOrientationService: IScreenOrientationService {
    func changeLockedInterfaceOrientation(_ orientation: UIInterfaceOrientationMask) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.lockedOrientation = orientation
        
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}
