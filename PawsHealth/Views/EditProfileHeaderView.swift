//
//  EditProfileHeaderView.swift
//  Locali.
//
//  Created by Pinto Diaz, Roger on 5/1/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import UIKit

final class EditProfileHeaderView: CBAutoXibView {

    // MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!

    func setupView(title: String) {
        lblTitle.text = title
    }
}
