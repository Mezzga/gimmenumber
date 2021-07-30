//
//  Validations.swift
//  SuitePaws
//
//  Created by Anand on 23/05/19.
//  Copyright © 2019 iTrust Concierge. All rights reserved.
//

import UIKit

class Validations {

    //Validate Email & mobile number
    static func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z.-_+]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"

        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: emailAddressString)
        /*do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0
            {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue*/
    }

    static func isValidPhoneNumber(phoneNumberString: String) -> Bool {

        let str =  phoneNumberString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var returnValue = true
        let phoneRegEx = "^\\d{10}$"
        do {
            let regex = try NSRegularExpression(pattern: phoneRegEx)
            let nsString = str as NSString
            let results = regex.matches(in: str, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0
            {
                returnValue = false
            }
            if(nsString.length != 10){
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }

    static func checkOnlynumbers(numberString: String) -> String {
        let str =  numberString.trim().components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return str
    }

    //Format mobile number
    static func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX)XXX-XXXX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }

    static func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
