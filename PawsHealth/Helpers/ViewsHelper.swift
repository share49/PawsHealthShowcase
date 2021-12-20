//
//  ViewsHelper.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 9/18/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import UIKit

final class ViewsHelper {

    static func addShowAndGetOpaqueLoadingView(to parentView: UIView) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)

        attachViewToSuperviewEdges(view: view, to: parentView)

        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.startAnimating()

        view.addAndCenter(view: activityIndicator)

        return view
    }

    // MARK: - Constraints
    static func attachViewToSuperviewEdges(view: UIView, to superview: UIView, topMargin: CGFloat = 0) {
        superview.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        let topConstraint = NSLayoutConstraint(
            item: view,
            attribute: .top,
            relatedBy: .equal,
            toItem: superview,
            attribute: .top,
            multiplier: 1,
            constant: topMargin
        )

        let rightConstraint = NSLayoutConstraint(
            item: view,
            attribute: .right,
            relatedBy: .equal,
            toItem: superview,
            attribute: .right,
            multiplier: 1,
            constant: 0
        )

        let bottomConstraint = NSLayoutConstraint(
            item: view,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: superview,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )

        let leftConstraint = NSLayoutConstraint(
            item: view,
            attribute: .left,
            relatedBy: .equal,
            toItem: superview,
            attribute: .left,
            multiplier: 1,
            constant: 0
        )

        superview.addConstraints([topConstraint, rightConstraint, bottomConstraint, leftConstraint])
    }
}
