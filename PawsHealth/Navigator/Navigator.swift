//
//  Navigator.swift
//  PawsHealth
//
//  Created by Roger Pintó Diaz on 1/2/19.
//  Copyright © 2019 Roger Pintó Diaz. All rights reserved.
//

import UIKit

protocol NavigatorProtocol: class {
    associatedtype Destination
    func navigate(to destination: Destination)
}

final class Navigator: NavigatorProtocol {
    
    private weak var navigationController: UINavigationController?
    
    init(_ navigationController: UINavigationController) {
        let navColor = UIColor.white
        self.navigationController = navigationController
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = R.color.pawHealthBlue()
        self.navigationController?.navigationBar.tintColor = navColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navColor]
    }
    
    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
            case .newPet(let delegate):
                return NewPetViewController.create(delegate: delegate)

            case .petDetail(let delegate, let pet):
                return PetDetailViewController.create(delegate: delegate, pet: pet)

            case .tip:
                return TipsViewController.create()

            case .weightDetail(let delegate, let pet, let index):
                return TrackWeightViewController.create(delegate: delegate, pet: pet, index: index)
        }
    }
}
