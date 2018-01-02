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
        
        endDateTextField.addTarget(self, action: #selector(selectedEndDatePicker), for: .allEvents)
        endDateTextField.text = "- -"
        
        textField.inputView = datePicker
        endDateTextField.inputView = endDatePicker
    }
    
    @objc func selectedEndDatePicker() {
        print("end date picker")
        self.endDatePicker.selectedStartDate(startDateSelected: false)
        endDatePicker.onDateSelected = { (weekDay: Int, day: Int, month: Int, year: Int) in
            let string = String(format: "%d/%d/%d", day , month, year)
            self.endDateTextField.text = self.endDatePicker.displayDate()
            NSLog(string)
        }
    }
    
    @objc func selectedStartDatePicker() {
        self.datePicker.selectedStartDate(startDateSelected: true)
        datePicker.onDateSelected = { (weekDay: Int, day: Int, month: Int, year: Int) in
            let string = String(format: "%d/%d/%d", day , month, year)
            self.textField.text = self.datePicker.displayDate()
            NSLog(string)
        }
    }    
}

