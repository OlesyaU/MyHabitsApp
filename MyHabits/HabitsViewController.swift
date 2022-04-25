//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Олеся on 21.04.2022.
//

import UIKit

class HabitsViewController: UIViewController {
    private let store = HabitsStore.shared
    
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            setNavigationBar()
        layout()
    }
    
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
    
    @objc private func addHibitButtonPushed(){
        let nextVC = UINavigationController(rootViewController: HabitViewController())
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.present(nextVC, animated: true)
        print("pushed button - addHibitButtonPushed")
    }
}
//MARK: Extensions
extension HabitsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.habits.count
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as! ProgressCollectionViewCell
        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.identifier, for: indexPath)
        
        
        if indexPath.item == 0 {
            cellLayout(cell: cell1)
            
           return cell1
        } else {
            cellLayout(cell: cell2)
            return cell2
        }
        
    }
    
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    private var constraint: CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: constraint, left: constraint, bottom: constraint, right: constraint)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - constraint * 2
        if indexPath.item == 0 {
           return CGSize(width: width, height: 65)
        } else {
            return CGSize(width: width, height: 140)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      constraint
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      constraint
    }
    private func cellLayout(cell: UICollectionViewCell) {
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .white
    
    }

}
