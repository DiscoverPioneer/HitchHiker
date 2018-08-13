//
//  UITextField+Helpers.swift
//  Call Logger
//
//  Created by Phil Scarfi on 5/30/17.
//  Copyright © 2017 Pioneer Mobile Applications. All rights reserved.
//

import Foundation
import UIKit

public enum TextFieldType {
    case regular
    case email
    case password
    case phoneNumber
}

public extension UITextField {
    public func isValid(type: TextFieldType) -> Bool {
        let text = self.text ??  ""
        let isEmpty = text.count == 0 || text.isEmpty
        
        switch type {
        case .regular:
            return !isEmpty
        case .email:
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: text) && !isEmpty
        case .password:
            return !isEmpty && text.count > 3
        case .phoneNumber:
            return !isEmpty && text.count == 17
        }
    }
    
    ///Add a toolbar above the keyboard with a done button that will dismiss the keyboard. This is good for phone number keyboards
    func addDoneButtonOnKeyboard(backgroundTint: UIColor = UIColor.gray
        , buttonTint: UIColor = UIColor.white) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 329, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackOpaque
        doneToolbar.isTranslucent = false
        doneToolbar.barTintColor = backgroundTint
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        done.tintColor = buttonTint
        doneToolbar.items = [flexSpace, done]
        if backgroundTint == .white {
            doneToolbar.layer.borderWidth = 1
            doneToolbar.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        }
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}

//MARK - Add Picker

extension UITextField {
    func usePickerView() -> UIPickerView {
        let picker = UIPickerView()
        inputView = picker
        return picker
    }
    
    func useDatePicker() -> UIDatePicker {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.date
        inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
        return datePicker
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let formattedDate = formatter.string(from: sender.date)
        text = formattedDate
    }
}
