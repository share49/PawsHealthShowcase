//
//  CatCell.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 6/26/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import UIKit

final class CatCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLastDate: UILabel!

    func setup(with pet: Pet) {
        lblName.text = pet.name.isEmpty ? ls.noNameYet() : pet.name
        lblLastDate.text = pet.formattedWeight
    }

    func setupWeightCell(with petWeight: PetWeight) {
        let isMetricSystem = Locale.current.usesMetricSystem
        let firstUnit: String = isMetricSystem ? "kg." : "lb"
        let secondUnit: String = isMetricSystem ? "g." : "lb"

        lblName.text = FormatterHelper.stringDate(from: petWeight.date)
        lblLastDate.text = "\(petWeight.weight) \(firstUnit), \(petWeight.meal) (\(petWeight.mealWeight) \(secondUnit))"
    }
}
