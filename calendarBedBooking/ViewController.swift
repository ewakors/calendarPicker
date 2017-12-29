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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let datePicker = CalendarPickerView()
        datePicker.onDateSelected = { (weekDay: Int, day: Int, month: Int, year: Int) in
            let string = String(format: "%d/%d/%d", day , month, year)
            NSLog(string)
        }
        textField.inputView = datePicker
    }
}

