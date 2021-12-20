//
//  ImageLoaderHelper.swift
//  ProjectPurple
//
//  Created by Pinto Diaz, Roger on 4/20/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import Kingfisher
import UIKit

struct ImageLoadHelper {

    static func load(_ imageUrl: String, in imageView: UIImageView) {
        guard let url = URL(string: imageUrl) else {
            MyLogE("ImageLoadHelper: Couldn't get URL for \(imageUrl)")
            return
        }

        imageView.kf.setImage(with: url)
    }
}
