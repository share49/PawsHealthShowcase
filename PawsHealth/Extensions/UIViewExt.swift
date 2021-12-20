//
//  UIViewExt.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 6/27/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import UIKit

// MARK: - UIView
extension UIView {
    func shadow(opacity: Float = 0.25, offset: CGFloat = 2) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: offset)
        self.layer.shadowOpacity = opacity
    }

    func mapPostShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.35
    }

    func filterPreviewShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 0.25
    }

    func roundedCornersModalView() {
        self.layer.cornerRadius = 6
    }

    func roundedCorners(radius: CGFloat = 5) {
        self.layer.cornerRadius = radius
    }

    func circularView() {
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.layer.masksToBounds = true
    }

    func borderThin(color: UIColor) {
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }

    func border(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }

    func topRoundedCorners(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func constrainToCenterInSuperview() {
        constrainToCenterInView(superview!)
    }

    func constrainToCenterInView(_ superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0))
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0))
    }

    func addAndCenter(view: UIView) {
        addSubview(view)
        view.constrainToCenterInSuperview()
    }
}
