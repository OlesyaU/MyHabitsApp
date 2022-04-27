//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Олеся on 23.04.2022.
//

import UIKit

class HabitViewController: UIViewController {
    
    private let buttonHeight: CGFloat = 30
    private var colorHabit = UIColor()
    private var date = Date()
    private lazy var dateString = date.formatted(date: .omitted, time: .shortened)
    private var nameHabit: String = ""
    private let store = HabitsStore.shared
//    private var trackDates = [Date]()
//    private let habit = Habit(name: String(), date: Date(), trackDates: [Date](), color: UIColor())
    
//    MARK: UI - Elements
    private let labelHibitName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Text Semibold", size: 17)
        label.text = "НАЗВАНИЕ"
        label.textAlignment = .left
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "SF Pro Text Semibold", size: 17)
        textField.textColor = UIColor(named: "Blue")
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.textAlignment = .left
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.keyboardType = .namePhonePad
        textField.addTarget(self, action: #selector(keepButtonTapped), for: .primaryActionTriggered)
        textField.addTarget(self, action: #selector(tapToTextField), for: .touchUpInside)
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
        label.attributedText = String.mutatingString(string: text)
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
    
    private lazy var deleteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Text Regular", size: 17)
        label.textColor = .red
        label.text = "Удалить привычку"
        label.textAlignment = .center
        label.isHidden = true
        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(deleteHabitTap))
        label.addGestureRecognizer(gesture)
        return label
    }()
    
    private lazy var colorButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = CGFloat(buttonHeight / 2)
        button.backgroundColor = .cyan
        button.addTarget(self, action: #selector(chooseHabitColorButtonTapped), for: .touchUpInside)
        return button
    }()
    
//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        layout()
    }
    
//  MARK: Constraints, settings UI
    private func layout() {
        let leadingConstraint: CGFloat = 8
        let topConstraint: CGFloat = 16
        [labelHibitName, labelColorName, labelTime, labelTimeResult, deleteLabel, colorButton, textField, datePicker].forEach({view.addSubview($0)})
        
        NSLayoutConstraint.activate([
            labelHibitName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstraint),
            labelHibitName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraint),
            labelHibitName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingConstraint),
            labelHibitName.heightAnchor.constraint(equalToConstant: 30),
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstraint),
            textField.topAnchor.constraint(equalTo: labelHibitName.bottomAnchor, constant: leadingConstraint),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingConstraint),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            labelColorName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstraint),
            labelColorName.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: leadingConstraint ),
            labelColorName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingConstraint),
            
            colorButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstraint),
            colorButton.topAnchor.constraint(equalTo: labelColorName.bottomAnchor, constant: leadingConstraint ),
            colorButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            colorButton.widthAnchor.constraint(equalToConstant: buttonHeight),
            
            labelTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstraint),
            labelTime.topAnchor.constraint(equalTo: colorButton.bottomAnchor, constant: leadingConstraint ),
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
    
    
    private func setNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor(named: "Violet")
        navigationController?.navigationBar.tintColorDidChange()
        navigationItem.rightBarButtonItem = .init(title: "Сохранить", style: .done, target: self, action: #selector(keepButtonTapped))
        navigationItem.leftBarButtonItem = .init(title: "Отменить", style: .plain, target: self, action: #selector(cancelButtonTapped))
        view.backgroundColor = .white
   }
    func setUIForChosenHabit(habit: Habit){
        title = "Править"
        deleteLabel.isHidden = false
        textField.text = habit.name
        nameHabit = habit.name
        colorButton.backgroundColor = habit.color
        colorHabit = habit.color
        datePicker.date = habit.date
        date = habit.date
        let text = "Каждый день в \(habit.date.formatted(date: .omitted, time: .shortened))  "
        labelTimeResult.attributedText = String.mutatingString(string: text)
        
    }
    
//    MARK: Actions + Recognizers
    @objc private func chooseDatePickerTime()  {
        date = datePicker.date
        dateString = datePicker.date.formatted(date: .omitted, time: .shortened)
        let text = "Каждый день в \(dateString) "
        labelTimeResult.attributedText = String.mutatingString(string: text)
        
        print("from chooseDatePickerTime \(date)")
        print("from chooseDatePickerTime\(dateString)")
        print("chooseDatePickerTime")
   }
    
    @objc private func cancelButtonTapped() {
        nameHabit = textField.text ?? "."
        colorHabit = colorButton.backgroundColor ?? .clear
        date = datePicker.date
        dateString = date.formatted(date: .omitted, time: .shortened)
//        store.save()
        dismiss(animated: true)
        print("cancelButtonTapped")
    }
    
    @objc private func keepButtonTapped(){
        textField.resignFirstResponder()
        nameHabit = textField.text ?? "text is lost"
 date = datePicker.date
        colorHabit = colorButton.backgroundColor ?? .clear
        print("keepButtonTapped")
        print("имя привычки -  \(nameHabit)")
        print("Цвет привычки -  \(colorHabit)")
        print("дэйт стринг из кипБаттон\(dateString)")
        print("дата из кипБаттон \(date)")
        let newHabit = Habit(name: nameHabit, date: date, color: colorHabit)
        
        
        if nameHabit == newHabit.name, date == newHabit.date {
            print(newHabit.name, newHabit.date)
            print(nameHabit, dateString)
            nameHabit = textField.text ?? "text is lost"
            date = datePicker.date
            colorHabit = colorButton.backgroundColor ?? .clear
            
            newHabit.name = textField.text ?? "text is lost"
            newHabit.date = datePicker.date
            date = datePicker.date
            dateString = date.formatted(date: .omitted, time: .shortened)
            newHabit.color = colorHabit
            print(newHabit.name, newHabit.date)
            print(nameHabit, dateString)

//            let sameHabit =  store.habits.first(where: {_ in
//                nameHabit == newHabit.name
//            })
            
            store.save()
            print(" ВТОРОЙЙ Принт из сохранить с именем привычки \(nameHabit), \(newHabit.name) цвет  \(colorHabit), \(newHabit.name) время - \(dateString), \(newHabit.dateString)")
            
            
        } else {
            
            store.habits.append(newHabit)
            store.track(newHabit)
        }
//        store.save()
        dismiss(animated: true)
//       let dates =  store.habit(newHabit, isTrackedIn: date)
    }
    
    @objc private func tapToTextField() {
        textField.becomeFirstResponder()
    }
    
    func checkTheHabit() -> Habit{
        let habit =  Habit(name: nameHabit, date: date, color: colorHabit)
        if textField.text == habit.name || colorButton.backgroundColor == habit.color || datePicker.date ==  habit.date {
        }
        return habit
        
    }
    @objc private func deleteHabitTap() {
      print("store count 1 - \(store.habits.count)")
      for (index, value) in store.habits.enumerated() {
            if nameHabit == value.name, colorButton.backgroundColor == value.color, datePicker.date == value.date{
                print(value, index)
                store.habits.remove(at: index)
            }
       }
        dismiss(animated: true)
       print("store count 2 - \(store.habits.count)")
    }
    
    @objc private func chooseHabitColorButtonTapped() {
        let colorpicker = UIColorPickerViewController()
        colorpicker.delegate = self
        colorpicker.supportsAlpha = false
        colorpicker.selectedColor = colorButton.backgroundColor ?? .blue
        self.present(colorpicker, animated: true)
    }
}

// MARK: Extensions
extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        colorHabit = color
        colorButton.backgroundColor = color
    }
}

extension String {
    static func mutatingString(string: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string:string, attributes: [NSAttributedString.Key.font : UIFont(name: "SF Pro Text Regular", size: 17)!])
        let myRange = NSRange(location: 13, length: 9)
        attributedText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "Violet")!], range: myRange)
        return attributedText
    }
}
