//
//  FillCell.swift
//  Locali.
//
//  Created by Pinto Diaz, Roger on 5/1/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import UIKit

final class FillCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textField: UITextField!

    private var index: Int!
    var unit: String {
        if Locale.current.usesMetricSystem {
            return index == 0 ? "(kg.)" : ls.grams()
        } else {
            return ls.pounds()
        }
    }

    func setup(indexPath: IndexPath, weight: PetWeight?, lastMeal: String) {
        index = indexPath.row

        if index == 0 {
            lblTitle.text = ls.weight(unit)
            textField.keyboardType = .decimalPad

            if let weight = weight?.weight {
                textField.text = FormatterHelper.getFormattedDataBaseString(from: weight)
            }

        } else if index == 1 {
            lblTitle.text = ls.meal()
            textField.text = weight?.meal ?? lastMeal

        } else if index == 2 {
            lblTitle.text = ls.mealWeight(unit)
            textField.keyboardType = .decimalPad

            if let mealWeight = weight?.mealWeight {
                textField.text = FormatterHelper.getFormattedDataBaseString(from: mealWeight)
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
