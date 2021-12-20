//
//  DatePickerCell.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 7/7/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import UIKit

final class DatePickerCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var ctTopMarginDatePicker: NSLayoutConstraint!
    @IBOutlet weak var ctBottomMargin: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        lblTitle.text = ls.date()

        if #available(iOS 14.0, *) {
            datePicker.tintColor = .label
            ctTopMarginDatePicker.constant = 8
            ctBottomMargin.constant = 10
        }
    }

    func setup(stringDate: String?) {
        if let date = stringDate {
            datePicker.setDate(FormatterHelper.date(from: date), animated: false)
        } else {
            datePicker.setDate(Date(), animated: false)
        }
    }
}
