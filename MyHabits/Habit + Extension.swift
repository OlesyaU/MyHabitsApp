//
//  Habit + Extension.swift
//  MyHabits
//
//  Created by Олеся on 01.05.2022.
//

import UIKit

extension Habit {
    static func makeInitial() -> Habit {
        return Habit(
            name: "",
            date: Date(),
            trackDates: [],
            color: UIColor()
        )
    }
}
