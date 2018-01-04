//
//  ViewController.swift
//  calendarBedBooking
//
//  Created by ekorszaczuk on 29.12.2017.
//  Copyright © 2017 ekorszaczuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    let datePicker = CalendarPickerView()
    let endDatePicker = EndDateCalendarPickerView()
    var endDate: Date? = nil
    var startDate: Date? = nil
    var startDay: Int = 0
    var startMonth: Int = 0
    var startYear: Int = 0
    var startWeekday: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.text = datePicker.displayStartDate()
        textField.addTarget(self, action: #selector(selectedStartDatePicker), for: .allEvents)
        
        endDateTextField.text = "- -"
        endDateTextField.addTarget(self, action: #selector(selectedEndDatePicker), for: .allEvents)
        
        startWeekday = datePicker.startWeekday
        startDay = datePicker.startDay
        startMonth = datePicker.startMonth
        startYear = datePicker.startYear
        
        startDate = datePicker.createStartDate(startDay: startDay, startMonth: startMonth, startYear: startYear)
        endDate = datePicker.createStartDate(startDay: startDay + 1, startMonth: startMonth, startYear: startYear)
        endDatePicker.selectedDate(weekDay: startWeekday, day: startDay + 1, month: startMonth, year: startYear, endDateIsChanged: false)
        
        textField.inputView = datePicker
        endDateTextField.inputView = endDatePicker
    }
    
    @objc func selectedEndDatePicker() {
        
        if self.startDate?.compare(self.endDate!) == .orderedDescending || self.startDate! == self.endDate!{
            self.endDatePicker.selectedDate(weekDay: self.startWeekday, day: self.startDay, month: self.startMonth, year: self.startYear, endDateIsChanged: false)
            self.endDate = self.endDatePicker.createEndDate(endDay: self.startDay + 1, endMonth: self.startMonth, endYear: self.startYear)
        }
        
        endDatePicker.onDateSelected = { (weekDay: Int, day: Int, month: Int, year: Int) in
            
            self.endDateTextField.text = self.endDatePicker.displayDate()
            self.endDate = self.endDatePicker.createEndDate(endDay: day + 1, endMonth: month, endYear: year)

            if self.startDate?.compare(self.endDate!) == .orderedDescending || self.startDate! == self.endDate! {
                self.endDateTextField.text = self.endDatePicker.displayDate()
                self.endDatePicker.selectedDate(weekDay: self.startWeekday, day: self.startDay + 1, month: self.startMonth, year: self.startYear, endDateIsChanged: true)
                self.endDate = self.endDatePicker.createEndDate(endDay: self.startDay + 1, endMonth: self.startMonth, endYear: self.startYear)
            }

            print("end date: \(String(describing: self.endDate))")
     
        }
    }
    
    @objc func selectedStartDatePicker() {

        datePicker.onDateSelected = { (weekDay: Int, day: Int, month: Int, year: Int) in
            self.textField.text = self.datePicker.displayDate()
            self.startDate = self.datePicker.createStartDate(startDay: day + 1, startMonth: month, startYear: year)
            self.startWeekday = weekDay
            self.startDay = day + 1
            self.startMonth = month
            self.startYear = year
            print("\(String(describing: self.startDate))")
            
            if self.startDate?.compare(self.endDate!) == .orderedDescending || self.startDate! == self.endDate!{
                self.endDatePicker.selectedDate(weekDay: weekDay, day: self.startDay, month: self.startMonth, year: self.startYear, endDateIsChanged: false)
            }
        }
    }
}

