//
//  String+Helpers.swift
//  Call Logger
//
//  Created by Phil Scarfi on 6/4/17.
//  Copyright © 2017 Pioneer Mobile Applications. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var numbersInString: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
            .compactMap { pattern ~= $0 ? Character($0) : nil })
    }
    
    var toInt: Int? {return Int(self)}
    var image: UIImage? {
        return UIImage(named: self)
    }
    func returnIfFilled() -> String? {
        if count > 0 {
            return self.trimmingCharacters(in: .whitespaces)
        }
        return nil
    }
    
    func e164PhoneNumberFormat() -> String? {
        var replacement = replacingOccurrences(of: " ", with: "")
        replacement = replacement.replacingOccurrences(of: "(", with: "")
        replacement = replacement.replacingOccurrences(of: ")", with: "")
        replacement = replacement.replacingOccurrences(of: "-", with: "")
        if replacement.first == "+" && replacement.count > 11 {
            return replacement
        }
        return nil
    }
    
    static func formattedPhoneNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX-XXXX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func rawPhoneNumber() -> String {
        let unsafeChars = CharacterSet.decimalDigits.inverted  // Remove the .inverted to get the opposite result.
        let cleanChars  = self.components(separatedBy: unsafeChars).joined(separator: "")
        return cleanChars
    }
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func bulletList(text:String, bullet: String, bulletColor: UIColor, attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let r = text
        let attributedString = NSMutableAttributedString(string: r)
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))
        let greenColorAttribure = [NSAttributedString.Key.foregroundColor: bulletColor]
        do {

            let regex = try NSRegularExpression(pattern: bullet, options: NSRegularExpression.Options.caseInsensitive)

            regex.enumerateMatches(in: r as String, options: [], range: NSMakeRange(0, r.count), using: { (result, flags, pointer) -> Void in

                if let result = result{
                    attributedString.addAttributes(greenColorAttribure, range:result.range)
                }
            })

            return attributedString

        } catch {
            return attributedString
        }
    }
}
