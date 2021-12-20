//
//  File.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 7/4/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import Charts
import Foundation

final class ChartFormatter: IAxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
    }
}
