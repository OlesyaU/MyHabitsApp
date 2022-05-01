//
//  Date+Extension.swift
//  MyHabits
//
//  Created by Олеся on 21.04.2022.
//

import Foundation
import UIKit

extension Date {
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else {
                break
            }
            date = newDate
        }
        return dates
    }
    
    func humanFormat() -> String {
        if Calendar.current.isDateInToday(self) {
            return "Сегодня"
        } else if Calendar.current.isDateInYesterday(self) {
            return "Вчера"
        } else {
            return formatted(date: .long, time: .omitted)
        }
    }
}

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}
