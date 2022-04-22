//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Олеся on 21.04.2022.
//

import UIKit

class HabitsViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addHibitButtonPushed))
        navigationItem.rightBarButtonItem?.tintColor = .init(named: "Violet")
        navigationItem.title = "Сегодня"
        view.backgroundColor = .init(named: "White")
   
       
    }
    

    @objc private func addHibitButtonPushed(){
        print("pushed button")
    }
}
