//
//  DateExtension.swift
//  Brokery
//
//  Created by ToqaMohsen on 1/9/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import Foundation

    extension Date {
        func dayOfWeek() -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self).capitalized
            // or use capitalized(with: locale) if you want
        }
    }

