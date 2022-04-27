//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Олеся on 27.04.2022.
//

import UIKit

 final class HabitDetailsViewController: UIViewController {
     private let store = HabitsStore.shared
     
   
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
//        navigationItem.rightBarButtonItem?.title = "Править"
    }
    
     private func setNavBar() {
      navigationItem.rightBarButtonItem = .init(title: "Править", style: .plain, target: self, action: #selector(changeHabitButtonTapped))
       
         navigationController?.navigationBar.tintColor = UIColor(named: "Violet")
         navigationController?.navigationBar.tintColorDidChange()
//         navigationItem.rightBarButtonItem = .init(title: "Сохранить", style: .done, target: self, action: #selector(keepButtonTapped))
//         navigationItem.leftBarButtonItem = .init(title: "Отменить", style: .plain, target: self, action: #selector(cancelButtonTapped))
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
         navigationController?.pushViewController(HabitViewController(), animated: true)
     }
     
}
extension HabitDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        вот тут надо взять конкретную привычку и ее затреканные даты
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = String(indexPath.row)
     
//        тут надо взять привычку и ее даты и их поместить в лейбл...если привычка была затрекана сегодня - надо поставить чекмарку на эту ячейку
        cell.accessoryType = .checkmark
        cell.tintColor = UIColor.init(named: "Violet")
        return cell
    }
    
    
}

extension HabitDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let str = NSAttributedString(string: "АКТИВНОСТЬ", attributes: [NSAttributedString.Key.font : UIFont(name: "SF Pro Text Regular", size: 17)!])
        return "АКТИВНОСТЬ"
    }
}
