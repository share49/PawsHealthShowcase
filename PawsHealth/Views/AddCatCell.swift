//
//  AddCatCell.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 6/26/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import UIKit

final class AddCatCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var lblAdd: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        lblAdd.text = ls.addPawMember()
    }

    func setup(with text: String) {
        lblAdd.text = text
    }
}
