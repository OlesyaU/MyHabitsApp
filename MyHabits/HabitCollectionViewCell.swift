//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Олеся on 25.04.2022.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    let store = HabitsStore.shared
   

  private lazy var nameHabitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Text Semibold", size: 17)
        label.textColor = .systemGray
        label.numberOfLines = 2
      label.sizeToFit()
        return label
    }()
    
 private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false

            return imageView
        }()
    
    private lazy var strideLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Text Regular", size: 13)
        label.textColor = .lightGray
        label.text = "Каждый день в "
        return label
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Text Regular", size: 13)
        label.textColor = .systemGray
        label.text = "Счётчик: "
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [nameHabitLabel, strideLabel, counterLabel, imageView].forEach({contentView.addSubview($0)})
        let constraint: CGFloat = 16
        let height: CGFloat = 20
        let widthLabel: CGFloat = contentView.bounds.width - (contentView.bounds.width / 3)
        NSLayoutConstraint.activate([
            nameHabitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constraint),
            nameHabitLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constraint),
            nameHabitLabel.widthAnchor.constraint(equalToConstant: widthLabel),
            
           strideLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constraint),
            strideLabel.topAnchor.constraint(equalTo: nameHabitLabel.bottomAnchor, constant: constraint / 2),
            strideLabel.widthAnchor.constraint(equalToConstant: widthLabel),
            strideLabel.heightAnchor.constraint(equalToConstant: height),
            
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constraint),
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -constraint),
            counterLabel.heightAnchor.constraint(equalToConstant: height),
            counterLabel.widthAnchor.constraint(equalToConstant: widthLabel),
            
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: height * 2),
            imageView.widthAnchor.constraint(equalToConstant: height * 2), imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constraint)
       ])
   }
    
    func configure(habit: Habit) {
        nameHabitLabel.textColor = habit.color
        nameHabitLabel.text = habit.name
        strideLabel.text = habit.dateString
        counterLabel.text = "Счетчик: \(habit.trackDates.count)"
        imageView.tintColor = habit.color
        if store.habit(habit, isTrackedIn: habit.date) {
            imageView.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            imageView.image = UIImage(systemName: "circle")
            }
    }
  
}
