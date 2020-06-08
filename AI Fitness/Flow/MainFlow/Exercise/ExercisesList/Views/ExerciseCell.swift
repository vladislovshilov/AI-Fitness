//
//  ExerciseCell.swift
//  AI Fitness
//
//  Created by Vlados iOS on 6/8/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {

    // MARK: - IBOutlet's
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func reload(title: String, description: String, icon: UIImage?, cellIndex: Int) {
        titleLabel.text = title
        descriptionLabel.text = description
        iconImageView.image = icon
        
        let backgroundImage = cellIndex % 2 == 0 ? UIImage(named: "exercise-orange") : cellIndex % 3 == 0 ? UIImage(named: "exersice-purple") : UIImage(named: "exercise-blue")
        backgroundImageView.image = backgroundImage
    }
}
