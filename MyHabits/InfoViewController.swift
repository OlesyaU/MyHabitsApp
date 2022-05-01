//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Олеся on 21.04.2022.
//

import UIKit

final class InfoViewController: UIViewController {
    
    //    MARK: Properties and objects
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.textAlignment = .left
        let text = """
Привычка за 21 день

Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:

1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.

2. Выдержать 2 дня в прежнем состоянии самоконтроля.

3. Отметить в дневнике первую неделю изменений и подвести первые итоги – что оказалось тяжело, что – легче, с чем еще предстоит серьезно бороться.

4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.

5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.

6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.

Источник: psychbook.ru

"""
        let mutText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont(name: "SF Pro Text", size: 17)!])
        let myRange = NSRange(location: 0, length: 20)
        mutText.addAttributes([NSAttributedString.Key.font: UIFont(name: "SF Pro Display", size: 20)!], range: myRange)
        textView.attributedText = mutText
        return textView
    }()
    
    //   MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Информация"
        layout()
    }
    
    //    MARK: Layout
    
    private func layout() {
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}
