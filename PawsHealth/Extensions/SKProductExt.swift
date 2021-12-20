//
//  SKProductExt.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 9/18/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import Foundation
import StoreKit.SKProduct

extension SKProduct {

    static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }

    var localizedPrice: String {
        let formatter = SKProduct.formatter
        formatter.locale = priceLocale

        guard let formattedPrice = formatter.string(from: price) else {
            return ""
        }

        return formattedPrice
    }
}
