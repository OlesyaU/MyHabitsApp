//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Олеся on 23.04.2022.
//

import UIKit

protocol HabitViewControllerDelegate: AnyObject {
    func didChangeHabit()
    func didUpdateProgress() 
}

final class HabitViewController: UIViewController {
    
    //    MARK: Properties and objects
    
    weak var delegate: HabitViewControllerDelegate?
    enum State {
        case new
        case edit
    }
    private var currentState: State = .new {
        didSet {
            updateState()
        }
    }
    private var habit = Habit.makeInitial()
    private let buttonHeight: CGFloat = 30
    private var colorHabit = UIColor()
    private var date = Date()
    private lazy var dateString = date.formatted(date: .omitted, time: .shortened)
    private var nameHabit = ""
    private let store = HabitsStore.shared
    private var isTrack = false
    private var correctName = ""
    private var correctColor = UIColor()
    private var correctDate = Date()
    
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
        textField.delegate = self
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
        button.backgroundColor = .systemGray2
        button.addTarget(self, action: #selector(chooseHabitColorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //    MARK: Lifecycle
    
    init(state: State, habit: Habit) {
        self.currentState = state
        self.habit = habit
        super .init(nibName: nil, bundle: nil)
        updateState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        layout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    //  MARK: Layout, configure
    
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
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem = .init(title: "Отменить", style: .plain, target: self, action: #selector(cancelButtonTapped))
        view.backgroundColor = .white
    }
    
    private func updateState() {
        switch currentState {
            case .new:
                title = "Создать"
                textField.text = ""
                let dateNow = Date.now
                datePicker.date = dateNow
                chooseDatePickerTime()
                colorButton.backgroundColor = .systemGray2
                deleteLabel.isHidden = true
            case .edit:
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
    }
    
    //    MARK: Actions, Gestures
    
    @objc private func chooseDatePickerTime()  {
        date = datePicker.date
        dateString = datePicker.date.formatted(date: .omitted, time: .shortened)
        let text = "Каждый день в \(dateString) "
        labelTimeResult.attributedText = String.mutatingString(string: text)
    }
    
    @objc private func cancelButtonTapped() {
        currentState = .new
        dismiss(animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func keepButtonTapped(){
        textField.resignFirstResponder()
        
        switch currentState {
            case .new:
                nameHabit = textField.text ?? "text is lost"
                date = datePicker.date
                colorHabit = colorButton.backgroundColor ?? .clear
                
                habit = Habit(name: nameHabit, date: date, color: colorHabit)
                
                store.habits.append(habit)
                
                dismiss(animated: true) {
                    self.delegate?.didChangeHabit()
                }
                
            case .edit:
                guard let index = store.habits.firstIndex(where: { $0 == habit }) else { return }
                correctName = textField.text ?? "text is lost"
                correctDate = datePicker.date
                correctColor = colorButton.backgroundColor ?? .clear
                store.habits[index] = habit
                habit.name = correctName
                habit.date = correctDate
                habit.color = correctColor
                store.save()
                navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc private func tapToTextField() {
        textField.becomeFirstResponder()
    }
    
    @objc private func deleteHabitTap() {
        
        let alert = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \"\(nameHabit)\"", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Отменить", style: .default) { [self] _ in
            cancelButtonTapped()
        }
        
        let action2 = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            for (index, value) in self.store.habits.enumerated() {
                if self.nameHabit == value.name, self.colorButton.backgroundColor == value.color, self.datePicker.date == value.date{
                    self.store.habits.remove(at: index)
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true)
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

extension HabitViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
