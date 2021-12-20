//
//  UIViewControllerExt.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 6/27/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import UIKit

// MARK: - UIViewController
extension UIViewController {
    func showOkAlertWithMessage(title: String) {
        let alert = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ls.ok(), style: .cancel))
        alert.modalPresentationStyle = .popover
        present(alert, animated: true, completion: nil)
    }

    func showGoToSettingsAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ls.cancel(), style: .cancel))
        alert.addAction(UIAlertAction(title: ls.goToSettings(), style: .default, handler: { _ in
            Utils.showSettings()
        }))
        alert.modalPresentationStyle = .popover

        present(alert, animated: true, completion: nil)
    }

    func addTapGestureRecognizerToHideKeyboardTappingOutsideIt() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func is_portrait() -> Bool {
        return self.view.bounds.size.height > self.view.bounds.size.width
    }

    func is_landscape() -> Bool {
        return !is_portrait()
    }
}
