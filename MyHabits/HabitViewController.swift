//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Олеся on 23.04.2022.
//

import UIKit

class HabitViewController: UIViewController {
    
    private let buttonHeight: CGFloat = 40
    private let colorHabit = UIColor()
    private var date = Date()
    private lazy var dateString = date.formatted(date: .omitted, time: .shortened)
    private var nameHabit: String = ""
    private var trackDates = [Date]()
    private let habit = Habit(name: String(), date: Date(), trackDates: [Date](), color: UIColor())
    
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
        textField.placeholder = "Бегать по утрамб спать 8 часов и т.п."
        textField.textAlignment = .left
        textField.addTarget(HabitViewController.self, action: #selector(tapToTextField), for: .touchUpInside)
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
        let text = "Каждый день в \(dateString) "
        label.font = UIFont(name: "SF Pro Text Regular", size: 17)
        let attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont(name: "SF Pro Text Regular", size: 17)!])
        let myRange = NSRange(location: 13, length: 9)
        attributedText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "Violet")!], range: myRange)
        label.attributedText = attributedText
        label.textAlignment = .left
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = Date()
        datePicker.timeZone = .current
        datePicker.calendar = .current
        datePicker.addTarget(self, action: #selector(chooseDatePickerTime), for: .valueChanged)
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
    }
    
    private func setNavigationBar() {
        title = "Создать"
        navigationController?.navigationBar.tintColor = UIColor(named: "Violet")
        navigationController?.navigationBar.tintColorDidChange()
        navigationItem.rightBarButtonItem = .init(title: "Сохранить", style: .done, target: self, action: #selector(keepButtonTapped))
        navigationItem.leftBarButtonItem = .init(title: "Отменить", style: .plain, target: self, action: #selector(cancelButtonTapped))
        view.backgroundColor = .white
        
    }
    
    @objc private func chooseDatePickerTime()  {
        date = datePicker.date
        dateString = datePicker.date.formatted(date: .omitted, time: .shortened)
        
        let text = "Каждый день в \(dateString) "
        
        let attributedText = NSMutableAttributedString(string:text, attributes: [NSAttributedString.Key.font : UIFont(name: "SF Pro Text Regular", size: 17)!])
        let myRange = NSRange(location: 13, length: 9)
        attributedText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "Violet")!], range: myRange)
        
        print("from chooseDatePickerTime \(date)")
        print(" from chooseDatePickerTime\(dateString)")
        print("chooseDatePickerTime")
        
        labelTimeResult.attributedText = attributedText
        
    }
    
    @objc private func cancelButtonTapped() {
        print("cancelButtonTapped")
    }
    @objc private func keepButtonTapped(){
        textField.resignFirstResponder()
        nameHabit = textField.text ?? "text is lost"
        date = datePicker.date
        print("keepButtonTapped")
        print(nameHabit)
        print("дэйт стринг из кипБаттон\(dateString)")
        print("дата из кипБаттон \(date)")
    }
    
    @objc private func tapToTextField() {
        textField.becomeFirstResponder()
        
    }
    
    
}
