//
//  FormatterHelper.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 7/7/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import Foundation

struct FormatterHelper {

    static let dataBaseDateFormat = "yyyy/MM/dd"
    private static let dateFormat = "MMMdEEEYYYY"

    static func string(fromStringNumber stringNumber: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: stringNumber)?.stringValue ?? ""
    }

    static func getFormattedDataBaseString(from stringNumber: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_EN")

        let number = formatter.number(from: stringNumber)!
        formatter.locale = Locale.current
        return formatter.string(from: number)!
    }

    // MARK: - Dates

    /// Format a string date like: Wed, Jun 3, 2020
    static func stringDate(from stringDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dataBaseDateFormat
        let date = formatter.date(from: stringDate)!

        formatter.setLocalizedDateFormatFromTemplate(dateFormat)
        return formatter.string(from: date)
    }

    static func getDataBaseStringDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dataBaseDateFormat
        return formatter.string(from: date)
    }

    static func date(from stringDate: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = dataBaseDateFormat
        return formatter.date(from: stringDate)!
    }
}
