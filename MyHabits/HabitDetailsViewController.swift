//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Олеся on 27.04.2022.
//

import UIKit

final class HabitDetailsViewController: UIViewController {
    
    //    MARK: Properties and objects
    
    private let store = HabitsStore.shared
    private var habit = Habit.makeInitial()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        return tableView
    }()
    
    //    MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        layout()
    }
    
    //  MARK: Layout, configure
    
    func configure(habit: Habit) {
        self.habit = habit
        tableView.reloadData()
    }
    
    private func setNavBar() {
        navigationItem.rightBarButtonItem = .init(title: "Править", style: .plain, target: self, action: #selector(changeHabitButtonTapped))
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = UIColor(named: "Violet")
        navigationController?.navigationBar.tintColorDidChange()
        view.backgroundColor = .white
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //    MARK: Actions, Gestures
    @objc private func changeHabitButtonTapped() {
        let habitVC = HabitViewController(state: .edit, habit: habit)
        navigationController?.pushViewController(habitVC, animated: true)
    }
}

// MARK: Extensions

extension HabitDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        let date = HabitsStore.shared.dates[indexPath.row]
        cell.textLabel?.text = date.humanFormat()
        let isTrack = HabitsStore.shared.habit(habit, isTrackedIn: date)
        switch isTrack {
            case true:
                cell.accessoryType = .checkmark
                
            case false:
                cell.accessoryType = .none
        }
        cell.tintColor = UIColor.init(named: "Violet")
        return cell
    }
}

extension HabitDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

