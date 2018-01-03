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
    let endDatePicker = CalendarPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.text = datePicker.displayStartDate()
        textField.addTarget(self, action: #selector(selectedStartDatePicker), for: .allEvents)
        
        endDateTextField.text = "- -"
        endDateTextField.addTarget(self, action: #selector(selectedEndDatePicker), for: .allEvents)
        
        textField.inputView = datePicker
        endDateTextField.inputView = endDatePicker
    }
    
    @objc func selectedEndDatePicker() {
        selectedDatePicker(datePicker: endDatePicker, selectedTextField: endDateTextField, startDateSelected: false)
    }
    
    @objc func selectedStartDatePicker() {
        selectedDatePicker(datePicker: datePicker, selectedTextField: textField, startDateSelected: true)
    }
    
    func selectedDatePicker(datePicker: CalendarPickerView, selectedTextField: UITextField!, startDateSelected: Bool) {
        datePicker.selectedStartDate(startDateSelected: startDateSelected)
        datePicker.onDateSelected = { (weekDay: Int, day: Int, month: Int, year: Int) in
            selectedTextField.text = datePicker.displayDate()
            if startDateSelected {
                datePicker.startDay = day
            }
        }
    }
}

