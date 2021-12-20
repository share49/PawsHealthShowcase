//
//  Pet.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 6/26/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import Foundation

struct Pet: Codable {

    var colorName: String?
    var id: String!
    var imageUrl: String?
    var name: String
    var weight: [PetWeight]?

    var sortedWeights: [PetWeight] {
        weight?.sorted { $0.formattedDate > $1.formattedDate } ?? [PetWeight]()
    }

    var formattedWeight: String {
        if let recentWeight = sortedWeights.first {
            let isMetricSystem = Locale.current.usesMetricSystem
            let unit: String = isMetricSystem ? "kg." : "lb"
            return "\(recentWeight.weightDouble) \(unit), \(FormatterHelper.stringDate(from: recentWeight.date))"
        }
        return ls.noTrackedWeightYet()
    }

    func toJSON() -> [String: Any] {
        var properties: [String: Any] = ["name": name]

        if let imageUrl = imageUrl {
            properties["imageUrl"] = imageUrl
        }

        if let weight = weight, !weight.isEmpty {
            properties["weight"] = weight.map { $0.toJSON() }
        }

        return properties
    }

    func basicPropertiesToJSON() -> [String: Any] {
        var properties: [String: Any] = ["name": name]

        if let colorName = colorName {
            properties["colorName"] = colorName
        }

        if let imageUrl = imageUrl {
            properties["imageUrl"] = imageUrl
        }

        return properties
    }
}

struct PetWeight: Codable, Equatable {

    let date: String
    let weight: String
    let meal: String
    let mealWeight: String

    var weightDouble: Double {
        Double(weight) ?? 0
    }

    var formattedDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.date(from: date) ?? Date()
        return newDate
    }

    func toJSON() -> [String: Any] {
        [
            "date": date,
            "weight": weight,
            "meal": meal,
            "mealWeight": mealWeight
        ]
    }
}
