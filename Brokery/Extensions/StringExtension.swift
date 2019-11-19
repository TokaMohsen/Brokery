//
//  StringExtension.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/19/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", EmailAddressRegex)
        return emailTest.evaluate(with: self)
    }
    func isValidMobileNumber() -> Bool {
        let mobileTest = NSPredicate(format:"SELF MATCHES %@", MobilePhoneNumberRegex)
        return mobileTest.evaluate(with: self)
    }
}
