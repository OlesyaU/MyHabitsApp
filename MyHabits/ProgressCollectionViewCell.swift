//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Олеся on 25.04.2022.
//

import UIKit

final class ProgressCollectionViewCell: UICollectionViewCell {
    
    private let progressToday: Float  = HabitsStore.shared.todayProgress
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.clipsToBounds = true
        progress.layer.cornerRadius = 3
        progress.trackTintColor = .systemGray2
        progress.progressTintColor = UIColor(named: "Violet")
        return progress
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Text Semibold", size: 13)
        label.textColor = .systemGray
        label.text = "Всё получится!"
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Text Semibold", size: 13)
        label.textColor = .systemGray
        label.text = "\(progressToday * 1000)" + " %"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [progressView,textLabel, valueLabel].forEach({contentView.addSubview($0)})
        let constraint: CGFloat = 16
        let height: CGFloat = 20
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constraint),
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constraint),
            textLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: constraint),
            textLabel.heightAnchor.constraint(equalToConstant: height),
            
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constraint),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constraint),
            valueLabel.heightAnchor.constraint(equalToConstant: height),
            
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constraint),
            progressView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: constraint / 2),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constraint),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -constraint)
        ])
    }
    
    func configure() {
        progressView.progress = progressToday
        valueLabel.text = String(Int(Double(progressToday) * 100 )) + "%"
    }
}
