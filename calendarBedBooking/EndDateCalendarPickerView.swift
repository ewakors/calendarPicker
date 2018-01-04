//
//  EndDateCalendarPickerView.swift
//  calendarBedBooking
//
//  Created by ekorszaczuk on 04.01.2018.
//  Copyright © 2018 ekorszaczuk. All rights reserved.
//

import UIKit
import Foundation

class EndDateCalendarPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var weekDays: [String]!
    var days: [Int]!
    var months: [String]!
    var years: [Int]!
    var daysCount: Int!
    let minYear: Int = 2008
    var startDate: String = ""
    let dateFormatter = DateFormatter()
    var dateString: String = ""
    let calendar = Calendar(identifier: .gregorian)
    var selectedStartDate: Bool = true
    var endDateIsChanged: Bool = false
    
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
        self.selectedStartDate(weekDay: weekDayIndex, day: dayIndex, month: monthIndex, year: yearIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
        self.selectedStartDate(weekDay: weekDayIndex, day: dayIndex, month: monthIndex, year: yearIndex)
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
    
    func selectedStartDate(weekDay: Int, day: Int, month: Int, year: Int) {
        var selectedWeekDay = weekDay
        selectedWeekDay = calendar.component(.weekday, from: Date())
        let weekDayRow = selectedWeekDay - 1
        self.selectRow(weekDayRow, inComponent: 0, animated: false)
        
        var selectedDay: Int
        selectedDay = day
        selectedDay = calendar.component(.day, from: Date())
        self.selectRow(selectedDay - 1, inComponent: 1, animated: false)
        
        var selectedMonth = month
        selectedMonth = calendar.component(.month, from: Date())
        let monthRow = selectedMonth - 1
        self.selectRow(monthRow, inComponent: 2, animated: false)
        
        var selectedYear = year
        selectedYear = calendar.component(.year, from: Date())
        self.selectRow(selectedYear, inComponent: 3, animated: false)
        
        startDate = String(format: "%@ %d %@ %d", weekDays[weekDayRow], selectedDay, months[monthRow], selectedYear)
    }
    
    func selectedDate(weekDay: Int, day: Int, month: Int, year: Int, endDateIsChanged: Bool) {
        let components = DateComponents(timeZone: TimeZone.init(abbreviation: "UTC")!, year: year, month: (month) % 13, day: day, hour: 0, minute: 0, weekday: weekDay)
        
        let newDate = calendar.date(from: components)
        
        if let date = newDate {
            let newCompnent = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
           
            if endDateIsChanged {
                self.monthIndex = (newCompnent.month ?? 0 ) - 1
                self.yearIndex = ((years.index(of: newCompnent.year ?? 0)) ?? 0)
                self.dayIndex = ((days.index(of: newCompnent.day ?? 0)) ?? 0) - 1
                self.weekDayIndex = ((newCompnent.weekday ?? 0) - 2) % 7
                dateString = String(format: "%@ %d %@ %d", weekDays[weekDayIndex], day - 1, months[monthIndex], year)
            } else {
                self.monthIndex = (newCompnent.month ?? 0 ) - 1
                self.yearIndex = ((years.index(of: newCompnent.year ?? 0)) ?? 0)
                self.weekDayIndex = ((newCompnent.weekday ?? 0) - 1) % 7
                self.dayIndex = ((days.index(of: newCompnent.day ?? 0)) ?? 0)
                dateString = String(format: "%@ %d %@ %d", weekDays[weekDayIndex], day, months[monthIndex], year)
            }
        }
        
        onDateSelected?(weekDay, day, month, year)
    }

    func displayStartDate() -> String {
        let startDate = self.startDate
        
        return startDate
    }

    func displayDate() -> String {
        let date = self.dateString
        
        return date
    }
    
    func createEndDate(endDay: Int, endMonth: Int, endYear: Int) -> Date? {
        var endDate: Date?
        var endComponents = DateComponents()
        endComponents.day = endDay
        endComponents.month = endMonth
        endComponents.year = endYear
        
        endDate = calendar.date(from: endComponents)
        return endDate
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
        var year = years[self.selectedRow(inComponent: 3)]
        
        endDateIsChanged = true
        
        let dateComponents = DateComponents(timeZone: TimeZone.init(abbreviation: "UTC")!, year: year, month: (month) % 13, day: 1, hour: 0, minute: 0)
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.init(abbreviation: "UTC")!
        let date = calendar.date(from: dateComponents)
        let range = calendar.range(of: .day, in: .month, for: date!)
        daysCount = range?.count ?? 0
        
        if year <= minYear {
            year = minYear
        }
        
        if days[day] >= daysCount {
            day = daysCount
            selectedDate(weekDay: weekDay, day: day, month: month, year: year, endDateIsChanged: false)
            
        } else {
            let newDay = day + 1
            selectedDate(weekDay: weekDay, day: newDay, month: month, year: year, endDateIsChanged: false)
        }
        
//        if !selectedStartDate {
//            print("start day i picker view \(startDay)")
//            if days[day] <= startDay {
//                print("start day i picker view \(startDay)")
//            }
//            var startDate: Date?
//            var endDate: Date?
//            var startComponents = DateComponents()
//            startComponents.day = startDay
//                        startComponents.month = month
//                        startComponents.year = year
//
//                        startDate = calendar.date(from: startComponents)
//
//                        var components = DateComponents()
//                        components.day = days[day]
//                        components.month = month
//                        components.year = year
//                        endDate = calendar.date(from: components)
//                        if startDate?.compare((endDate)!) == .orderedDescending {
//                            print ("start date is smaller")
//                            selectedDate(weekDay: weekDay, day: startDay + 1, month: month, year: year)
//                        }
//        }
        
        pickerView.reloadAllComponents()
    }
}


//var components = DateComponents()
//components.day = day
//components.month = month
//components.year = year
//
//var startComponents = DateComponents()
//startComponents.day = startDay
//startComponents.month = month
//startComponents.year = startYear
//
//let endDate = calendar.date(from: components)
//let startDate = calendar.date(from: startComponents)
//
//if startDate?.compare(endDate!) == .orderedDescending {
//    print ( "start date is smaller")
//    day = startDay
//}

//        var components = DateComponents()
//        components.weekday = weekDay
//        components.day = day
//        components.month = month
//        components.year = year
//
//        let date = calendar.date(from: components)
//        dateFormatter.dateFormat = "EE dd MMMM yyyy"
//        if let date = date {
//            self.startDate = dateFormatter.string(from: date)
//            return startDate
//        }
//
//        return ""