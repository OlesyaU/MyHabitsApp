//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Олеся on 23.04.2022.
//

import UIKit

class HabitViewController: UIViewController {
    
    private let buttonHeight: CGFloat = 40
//    private let colorHabit: UIColor? = nil
//    private let date: Date? = nil
    private let nameHabit: String = ""
    
    
    
//    private let habit = Habit(from: Codable.self as! Decoder)
    
    private let labelHibitName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Text Semibold", size: 17)
        label.text = "НАЗВАНИЕ"
        label.textAlignment = .left
        return label
    }()
    private let textField: UITextField = {
           let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "SF Pro Text Semibold", size: 17)
        textField.textColor = UIColor(named: "Blue")
        textField.placeholder = "Выпить стакан воды"
        textField.textAlignment = .left
        textField.keyboardAppearance = .alert
         return textField
       }()
    
    private let labelColorName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Text Semibold", size: 17)
        label.text = "ЦВЕТ"
        label.textAlignment = .left
        return label
    }()
    
    private let labelTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Text Semibold", size: 17)
        label.text = "ВРЕМЯ"
        label.textAlignment = .left
        return label
    }()
    private lazy var labelTimeResult: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Text Regular", size: 17)
//        label.text = habit.dateString
        label.textAlignment = .left
        return label
    }()
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .automatic
      datePicker.timeZone = .current
        datePicker.calendar = .current
        return datePicker
    }()
    
    private let deleteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Text Regular", size: 17)
        label.textColor = .red
        label.text = "Удалить привычку"
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var colorButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = CGFloat(buttonHeight / 2)
        button.backgroundColor = .cyan
        return button
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        layout()
    }
    private func layout() {
        let leadingConstraint: CGFloat = 16
        let topConstraint: CGFloat = 20
        [labelHibitName, labelColorName, labelTime, labelTimeResult, deleteLabel, colorButton, textField, datePicker].forEach({view.addSubview($0)})
        
        NSLayoutConstraint.activate([
           labelHibitName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstraint),
           labelHibitName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraint),
           labelHibitName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingConstraint),
           labelHibitName.heightAnchor.constraint(equalToConstant: 30),
           
           textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstraint),
           textField.topAnchor.constraint(equalTo: labelHibitName.bottomAnchor, constant: leadingConstraint / 2),
           textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingConstraint),
           textField.heightAnchor.constraint(equalToConstant: 40),
           
           labelColorName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstraint),
           labelColorName.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: leadingConstraint / 2),
           labelColorName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingConstraint),
           
           colorButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstraint),
           colorButton.topAnchor.constraint(equalTo: labelColorName.bottomAnchor, constant: leadingConstraint / 2),
           colorButton.heightAnchor.constraint(equalToConstant: buttonHeight),
           colorButton.widthAnchor.constraint(equalToConstant: buttonHeight),
           
           labelTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstraint),
           labelTime.topAnchor.constraint(equalTo: colorButton.bottomAnchor, constant: leadingConstraint / 2),
           labelTime.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingConstraint),
           labelTimeResult.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstraint),
           labelTimeResult.topAnchor.constraint(equalTo: labelTime.bottomAnchor, constant: leadingConstraint / 2),
           labelTimeResult.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingConstraint),
           datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           datePicker.topAnchor.constraint(equalTo: labelTimeResult.bottomAnchor, constant: leadingConstraint),
           datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),

           deleteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstraint),
           deleteLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -topConstraint),
           deleteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingConstraint)
        
        ])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if textField.text == "" {
            title = "Создать"
        } else {
            title = "Править"
        }
    }
    
    private func setNavigationBar() {
       navigationController?.navigationBar.tintColor = UIColor(named: "Violet")
        navigationController?.navigationBar.tintColorDidChange()
        navigationItem.rightBarButtonItem = .init(title: "Сохранить", style: .done, target: self, action: #selector(keepButtonTapped))
        navigationItem.leftBarButtonItem = .init(title: "Отменить", style: .plain, target: self, action: #selector(cancelButtonTapped))
        view.backgroundColor = .white
        
    }
    
    @objc private func cancelButtonTapped() {
        print("cancelButtonTapped")
    }
    @objc private func keepButtonTapped(){
        print("keepButtonTapped")
    }

}
