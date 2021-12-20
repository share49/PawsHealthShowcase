//
//  Destination.swift
//  PawsHealth
//
//  Created by Roger Pintó Diaz on 1/2/19.
//  Copyright © 2019 Roger Pintó Diaz. All rights reserved.
//

import UIKit

enum Destination {
    case newPet(delegate: PetListener)
    case petDetail(delegate: PetListener, pet: Pet)
    case tip
    case weightDetail(delegate: PetListener, pet: Pet, index: Int?)
}
