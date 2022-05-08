//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Олеся on 21.04.2022.
//

import UIKit

final class HabitsViewController: UIViewController {
    
    //    MARK: Properties and objects
    
    private var store = HabitsStore.shared
    private var habitDetailsViewController = HabitDetailsViewController()
    private enum SectionType: Int, CaseIterable {
        case progress
        case habit
        
        init?(section: Int) {
            switch section {
                case 0: self = .progress
                case 1 : self = .habit
                case let unknowned:
                    fatalError("Couldn't initialize section type for section index \(unknowned)")
            }
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor(named: "White")
        collection.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.identifier)
        collection.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.identifier)
        return collection
    }()
    
    //   MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        layout()
        print(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        print(#function)
    }
    
    //    MARK: - Layout, configure
    
    private func layout() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addHibitButtonPushed))
        navigationItem.rightBarButtonItem?.tintColor = .init(named: "Violet")
        navigationItem.title = "Сегодня"
    }
    
    // MARK: - Actions, Gestures
    
    @objc private func addHibitButtonPushed(){
        let nextVC = UINavigationController(rootViewController: HabitViewController(state: .new, habit: Habit.makeInitial()))
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.present(nextVC, animated: true)
    }
}

//MARK: - Extensions
// MARK: - UICollectionViewDataSource

extension HabitsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = SectionType(section: section) else { return .zero }
        switch sectionType {
            case .progress:
                return   1
            case .habit:
                return  store.habits.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        SectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = SectionType(section: indexPath.section) else { return .init() }
        switch sectionType {
            case .progress:
                let progress = HabitsStore.shared.todayProgress
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as! ProgressCollectionViewCell
                cell.configure(progress: progress)
                return cell
            case .habit:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.identifier, for: indexPath) as! HabitCollectionViewCell
                let habit = store.habits[indexPath.item]
                cell.configure(habit: habit)
                cell.delegate = self
                return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let habit = store.habits[indexPath.item]
        navigationController?.pushViewController(habitDetailsViewController, animated: true)
        habitDetailsViewController.title = habit.name
        habitDetailsViewController.configure(habit: habit)
    }
}
// MARK: - UICollectionViewDelegateFlowLayout

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Layout.sectionEdgeInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - Layout.baseInset * 2
        guard let sectionType = SectionType(section: indexPath.section) else {return .zero}
        
        switch sectionType {
            case .progress:
                return CGSize(width: width, height: Layout.progressCellHeight)
            case .habit:
                return CGSize(width: width, height: Layout.habitCellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Layout.baseInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Layout.baseInset
    }
}


extension HabitsViewController {
    private enum Layout {
        static let progressCellHeight = CGFloat(65)
        static let habitCellHeight = CGFloat(140)
        static let baseInset = CGFloat(16)
        static let sectionEdgeInset = UIEdgeInsets(
            top: baseInset,
            left: baseInset,
            bottom: baseInset,
            right: baseInset
        )
    }
}

// MARK: - HabitViewControllerDelegate

extension HabitsViewController: HabitViewControllerDelegate {
    func didChangeHabit() {
        collectionView.reloadData()
        print(#function)
    }
}


