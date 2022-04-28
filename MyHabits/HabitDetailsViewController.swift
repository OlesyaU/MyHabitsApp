//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Олеся on 27.04.2022.
//

import UIKit

final class HabitDetailsViewController: UIViewController {
    private let store = HabitsStore.shared.dates
//    private var datesCount = Int()
//    private var dates = [Date]()
//    private var isTrack = Bool()
//    private var name = String()
    var habitDVC = Habit(name: String(), date: Date(), trackDates: [Date](), color: UIColor())
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        return tableView
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        layout()
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
    
    @objc private func changeHabitButtonTapped() {
        let habitVC = HabitViewController()
        let nextVC = UINavigationController(rootViewController: habitVC)
//        nextVC.modalPresentationStyle = .fullScreen
//        navigationController?.present(nextVC, animated: true, completion: {
//            habitVC.setUIForChosenHabit(habit: self.habitDVC)
//
//        }) нам надо его пушить и переписать все методы
        navigationController?.pushViewController(habitVC, animated: true)
        habitVC.setUIForChosenHabit(habit: habitDVC)
    }
    func configure(habit: Habit) {
        habitDVC = habit
        tableView.reloadData()
    }
    
}
extension HabitDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
let relativeDateFormatter = RelativeDateTimeFormatter()
        let date = HabitsStore.shared.dates[indexPath.row]
        relativeDateFormatter.calendar = .current
        relativeDateFormatter.dateTimeStyle = .named
        if Calendar.current.isDateInToday(date) {
            cell.textLabel?.text = "Сегодня"
        } else if  Calendar.current.isDateInYesterday(date) {
            cell.textLabel?.text = "Вчера"
} else {
    
            cell.textLabel?.text = date.formatted(date: .long, time: .omitted)
        }
//        вот тут я ставила чекмарку если она затрекана сегодня
//        if habitDVC.isAlreadyTakenToday {
//            cell.accessoryType = .checkmark
//        }
        
        let isTrackkk = HabitsStore.shared.habit(habitDVC, isTrackedIn: date)
        if isTrackkk {
            cell.accessoryType = .checkmark
        }
        
        cell.tintColor = UIColor.init(named: "Violet")
        return cell
    }
    
    
}

extension HabitDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
}
