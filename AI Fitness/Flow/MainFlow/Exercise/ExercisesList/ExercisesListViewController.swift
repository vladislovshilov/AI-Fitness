//
//  ExerciseViewController.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import UIKit

class ExercisesListViewController: BaseController {
    typealias ViewModel = IExercisesListViewModel
    
    private struct Constants {
        private init() {}
        static let cellHeight: CGFloat = 140
    }
    
    // MARK: - IBOutlet's
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Handler's
    var onExerciseTapHandler: (() -> Void)?

    // MARK: - Properties
    var viewModel: IExercisesListViewModel
    
    // MARK: - Initialization
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        tableView.register(UINib(nibName: "ExerciseCell", bundle: nil), forCellReuseIdentifier: "ExerciseCell")
    }
}

// MARK: - ViewModelUpdatable

extension ExercisesListViewController: ViewModelUpdatable {
    func updateView(with viewModel: ViewModel) {
        
    }
}

// MARK: - UITableViewDataSource

extension ExercisesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exercisesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exercise = viewModel.exerciseForIndex(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCell
        cell.reload(title: exercise.name, description: exercise.description, icon: UIImage(named: "pushups"), cellIndex: indexPath.row + 1)
        return cell
    }
}

extension ExercisesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.showExerciseDescriptionScreen(forIndex: indexPath.row)
    }
}

