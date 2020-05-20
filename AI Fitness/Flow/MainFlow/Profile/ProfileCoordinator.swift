//
//  ProfileCoordinator.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import UIKit

final class ProfileCoordinator {
    private let router: Routable
    
    //MARK: Initialization
    required init(router: Routable) {
        self.router = router
    }
}

extension ProfileCoordinator: TabBarItemSupportable {
    var image: UIImage? {
        return R.image.profileIcon()
    }
    
    var selectedImage: UIImage? {
        return R.image.profileIconFill()
    }
    
    var title: String {
        return "Profile"
    }
}

extension ProfileCoordinator: Coordinatable {
    func start() {
        let view = ProfileViewController(nibName: nil, bundle: nil)
        
        router.setRootModule(view)
    }
}
