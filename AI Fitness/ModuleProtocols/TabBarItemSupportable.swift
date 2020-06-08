//
//  TabBarItemSupportable.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shiov. All rights reserved.
//

import UIKit

protocol TabBarItemSupportable {
    var title: String { get }
    var image: UIImage? { get }
    var selectedImage: UIImage? { get }
    var item: UITabBarItem { get }
}

extension TabBarItemSupportable {
    var item: UITabBarItem {
        return UITabBarItem(title: title,
                            image: image,
                            selectedImage: selectedImage)
    }
}
