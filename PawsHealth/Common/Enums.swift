//
//  Enums.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 7/7/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import UIKit

enum Colors: String, CaseIterable {
    case systemTeal
    case systemBlue
    case systemPink
    case systemRed
    case systemGray
    case darkGray
    case systemGreen
    case systemYellow

    static func getString(from color: UIColor) -> String {
        let cgColor = color.cgColor

        if cgColor == UIColor.systemTeal.cgColor {
            return Colors.systemTeal.rawValue

        } else if cgColor == UIColor.systemBlue.cgColor {
            return Colors.systemBlue.rawValue

        } else if cgColor == UIColor.systemPink.cgColor {
            return Colors.systemPink.rawValue

        } else if cgColor == UIColor.systemRed.cgColor {
            return Colors.systemRed.rawValue

        } else if cgColor == UIColor.systemGray.cgColor {
            return Colors.systemGray.rawValue

        } else if cgColor == UIColor.darkGray.cgColor {
            return Colors.darkGray.rawValue

        } else if cgColor == UIColor.systemGreen.cgColor {
            return Colors.systemGreen.rawValue

        } else if cgColor == UIColor.systemYellow.cgColor {
            return Colors.systemYellow.rawValue
        }

        return ""
    }

    static func getColor(from string: String) -> UIColor {
        if string == Colors.systemTeal.rawValue {
            return .systemTeal

        } else if string == Colors.systemBlue.rawValue {
            return .systemBlue

        } else if string == Colors.systemPink.rawValue {
            return .systemPink

        } else if string == Colors.systemRed.rawValue {
            return .systemRed

        } else if string == Colors.systemGray.rawValue {
            return .systemGray

        } else if string == Colors.darkGray.rawValue {
            return .darkGray

        } else if string == Colors.systemGreen.rawValue {
            return .systemGreen

        } else if string == Colors.systemYellow.rawValue {
            return .systemYellow
        }

        return UIColor()
    }
}
