//
//  CalendarPickerView.swift
//  calendarBedBooking
//
//  Created by ekorszaczuk on 29.12.2017.
//  Copyright © 2017 ekorszaczuk. All rights reserved.
//

import Foundation

import UIKit
import Foundation

class CalendarPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var weekDays: [String]!
    var days: [Int]!
    var months: [String]!
    var years: [Int]!
    var daysCount: Int!
    var yearsCount: Int!
    let calendar = Calendar(identifier: .gregorian)
    
    var weekDayIndex: Int = 0 {
        didSet {
            selectRow(weekDayIndex, inComponent: 0, animated: true)
        }
    }
    
    var dayIndex: Int = 0 {
        didSet {
            selectRow(dayIndex, inComponent: 1, animated: true)
        }
    }
    
    var monthIndex: Int = 0 {
        didSet {
            selectRow(monthIndex, inComponent: 2, animated: false)
        }
    }
    
    var yearIndex: Int = 0 {
        didSet {
            selectRow(yearIndex, inComponent: 3, animated: true)
        }
    }
    
    var onDateSelected: ((_ weekDay: Int, _ day: Int, _ month: Int, _ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
        self.selectedTodayDate(weekDay: weekDayIndex, day: dayIndex, month: monthIndex, year: yearIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
        self.selectedTodayDate(weekDay: weekDayIndex, day: dayIndex, month: monthIndex, year: yearIndex)
    }
    
    func commonSetup() {
        let years: [Int] = Array(0...3000)
        self.years = years
        
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months
        
        let days: [Int] = Array(1...31)
        self.days = days
        
        let weekDays: [String] = Calendar.current.shortWeekdaySymbols
        self.weekDays = weekDays
        
        self.delegate = self
        self.dataSource = self
    }
    
    func selectedTodayDate(weekDay: Int, day: Int, month: Int, year: Int) {
        var selectedWeekDay = weekDay
        selectedWeekDay = calendar.component(.weekday, from: Date())
        self.selectRow(selectedWeekDay - 1, inComponent: 0, animated: false)
        
        var selectedDay = day
        selectedDay = calendar.component(.day, from: Date())
        self.selectRow(selectedDay - 1, inComponent: 1, animated: false)
        
        var selectedMonth = month
        selectedMonth = calendar.component(.month, from: Date())
        self.selectRow(selectedMonth - 1, inComponent: 2, animated: false)
        
        var selectedYear = year
        selectedYear = calendar.component(.year, from: Date())
        self.selectRow(selectedYear, inComponent: 3, animated: false)
    }
    
    func selectedDate(weekDay: Int, day: Int, month: Int, year: Int) {
        let components = DateComponents(timeZone: TimeZone.init(abbreviation: "UTC")!, year: year, month: (month) % 13, day: day, hour: 0, minute: 0)
        let newDate = calendar.date(from: components)
        
        if let date = newDate {
            print("date: \(date)")
            let newCompnent = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
            self.monthIndex = (newCompnent.month ?? 0 ) - 1
            self.yearIndex = ((years.index(of: newCompnent.year ?? 0)) ?? 0)
            self.dayIndex = ((days.index(of: newCompnent.day ?? 0)) ?? 0)
            self.weekDayIndex = ((newCompnent.weekday ?? 0) - 1) % 7
        }
        onDateSelected?(weekDay, day, month, year)
    }
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return weekDays[row]
        case 1:
            return "\(days[row])"
        case 2:
            return months[row]
        case 3:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return weekDays.count
        case 1:
            return days.count
        case 2:
            return months.count
        case 3:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let weekDay = self.selectedRow(inComponent: 0)
        var day = self.selectedRow(inComponent: 1) 
        let month = self.selectedRow(inComponent: 2) + 1
        let year = years[self.selectedRow(inComponent: 3)]
        
        let dateComponents = DateComponents(timeZone: TimeZone.init(abbreviation: "UTC")!, year: year, month: (month) % 13, day: 1, hour: 0, minute: 0)
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.init(abbreviation: "UTC")!
        let date = calendar.date(from: dateComponents)
        let range = calendar.range(of: .day, in: .month, for: date!)
        daysCount = range?.count ?? 0
        
        if days[day] >= daysCount {
            day = daysCount
            selectedDate(weekDay: weekDay, day: day, month: month, year: year)
            
        } else {
            let newDay = day + 1
            selectedDate(weekDay: weekDay, day: newDay, month: month, year: year)
        }

        pickerView.reloadAllComponents()
    }
}
