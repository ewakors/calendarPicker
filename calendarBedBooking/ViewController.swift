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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let datePicker = CalendarPickerView()
        textField.text = datePicker.displayStartDate()
        datePicker.onDateSelected = { (weekDay: Int, day: Int, month: Int, year: Int) in
            let string = String(format: "%d/%d/%d", day , month, year)
            self.textField.text = string
            NSLog(string)
        }
        
        textField.inputView = datePicker
    }
}

