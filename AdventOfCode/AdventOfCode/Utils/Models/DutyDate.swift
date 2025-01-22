//
//  DutyDate.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 15/3/22.
//

import Foundation

class DutyDate {
    private(set) var year: Int
    private(set) var month: Int
    private(set) var day: Int
    private(set) var hour: Int
    private(set) var minute: Int
    
    init(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
    }
    
    convenience init(_ value: String) {
        let items = value.replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
            .components(separatedBy: .whitespaces)
        let dateComponents = items[0].components(separatedBy: "-")
        let timeComponents = items[1].components(separatedBy: ":")
        self.init(Int(dateComponents[0])!,
                  Int(dateComponents[1])!,
                  Int(dateComponents[2])!,
                  Int(timeComponents[0])!,
                  Int(timeComponents[1])!)
    }
    
    func minutesTo(_ nextDate: DutyDate) -> Int {
        (((nextDate.year - year) * 365
          + (nextDate.month - month) * 30
          + (nextDate.day - day)) * 24
         + (nextDate.hour - hour)) * 60
        + (nextDate.minute - minute) - 1
    }
    
    func isInInterval(_ interval: (initDate: DutyDate, endDate: DutyDate)) -> Bool {
        self >= interval.initDate && self <= interval.endDate
    }
    
    func addMinute() -> DutyDate {
        let newDutyDate = DutyDate(year, month, day, hour, (minute + 1)%60)
        if newDutyDate.minute == 0 {
            newDutyDate.hour = (newDutyDate.hour+1)%24
            if newDutyDate.hour == 0 {
                newDutyDate.day = (newDutyDate.day+1)%30
                if newDutyDate.day == 0 {
                    newDutyDate.month = (newDutyDate.month+1)%12
                    newDutyDate.year += newDutyDate.month == 0 ? 1 : 0
                }
            }
        }
        return newDutyDate
    }
    
}

extension DutyDate: Hashable {
    
    func hash(into hasher: inout Hasher) { }
    
    static func == (lhs: DutyDate, rhs: DutyDate) -> Bool {
        lhs.year == rhs.year
        && lhs.month == rhs.month
        && lhs.day == rhs.day
        && lhs.hour == rhs.hour
        && lhs.minute == rhs.minute
    }
    
    static func < (lhs: DutyDate, rhs: DutyDate) -> Bool {
        lhs.year < rhs.year
        || (lhs.year == rhs.year && lhs.month < rhs.month)
        || (lhs.year == rhs.year && lhs.month == rhs.month && lhs.day < rhs.day)
        || (lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day && lhs.hour < rhs.hour)
        || (lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day && lhs.hour == rhs.hour && lhs.minute < rhs.minute)
    }
    
}

extension DutyDate: Comparable {
    
}
