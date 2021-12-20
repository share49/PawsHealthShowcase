//
//  OptionalExt.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 6/27/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import Foundation

// MARK: - Optional
extension Optional {
    var isNotNil: Bool {
        if case .none = self {
            return false
        }
        return true
    }
}
