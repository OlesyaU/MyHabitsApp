//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Олеся on 25.04.2022.
//

import UIKit

final class HabitCollectionViewCell: UICollectionViewCell {
    
    //    MARK: Properties and objects
    
    private let store = HabitsStore.shared
    private var isTracked = false
    private var habit: Habit?
    weak var delegate: HabitViewControllerDelegate?
    
    private  lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Text Semibold", size: 17)
        label.textColor = .systemGray
        label.numberOfLines = 2
        label.sizeToFit()
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(circleTapped))
        imageView.addGestureRecognizer(gesture)
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
    
    //   MARK: Lifecycle
    
    override init(frame: CGRect) {
 super.init(frame: frame)
        layer.cornerRadius = 10
        backgroundColor = .white
        layout()
        print(#function)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //    MARK: Layout, configure
    
    func configure(habit: Habit) {
        self.habit = habit
        nameLabel.textColor = habit.color
        nameLabel.text = habit.name
        strideLabel.text = habit.dateString
        counterLabel.text = "Счётчик: \(habit.trackDates.count)"
        imageView.tintColor = habit.color
        isTracked = habit.isAlreadyTakenToday
        if habit.isAlreadyTakenToday {
            imageView.image = UIImage(systemName: "checkmark.circle.fill")
            
        } else {
            imageView.image = UIImage(systemName: "circle")
        }
    }
    
    private func layout() {
        [nameLabel, strideLabel, counterLabel, imageView].forEach({contentView.addSubview($0)})
        
        let widthLabel: CGFloat = contentView.bounds.width - (contentView.bounds.width / 3)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.basicInset),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.basicInset),
            nameLabel.widthAnchor.constraint(equalToConstant: widthLabel),
            
            strideLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.basicInset),
            strideLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Layout.basicInset / 2),
            strideLabel.widthAnchor.constraint(equalToConstant: widthLabel),
            strideLabel.heightAnchor.constraint(equalToConstant: Layout.height),
            
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.basicInset),
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.basicInset),
            counterLabel.heightAnchor.constraint(equalToConstant: Layout.height),
            counterLabel.widthAnchor.constraint(equalToConstant: widthLabel),
            
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Layout.height * 2),
            imageView.widthAnchor.constraint(equalToConstant: Layout.height * 2), imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.basicInset)
        ])
    }
    
    //    MARK: Actions, Gestures
    
    @objc   func circleTapped(){
        guard let habit = habit else { return }
        switch habit.isAlreadyTakenToday {
            case true:
                return
            case false:
                isTracked.toggle()
                imageView.image = UIImage(systemName: "checkmark.circle.fill")
                HabitsStore.shared.track(habit)
                HabitsStore.shared.save()
                counterLabel.text = "Счётчик: \(habit.trackDates.count)"
                let progress = ProgressCollectionViewCell()
                progress.progress = HabitsStore.shared.todayProgress
                self.delegate?.didChangeHabit()
       }
    }
}

//MARK: Extensions

extension HabitCollectionViewCell {
    private enum Layout {
        static let basicInset = CGFloat(16)
        static let height = CGFloat(20)
    }
    
}
