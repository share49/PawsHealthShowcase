//
//  CBAutoXibView.swift
//  ProjectPurple
//
//  Created by Pinto Diaz, Roger on 4/7/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import UIKit

/// A subclass of CBXibView that loads a xib file with the same name of the class.
///
/// This is the base class for all our reusable views.
///
/// When you want to build a reusable view (or component), you create a subclass of CBAutoXibView
/// and a xib file with the same name of the subclass. Then, when you instantiate the subclass, it
/// will automagically load the contents of the nib file.
///
/// If you want to have acces to the views in the xib file from your subclass: in the xib file,
/// you must set the file's owner placeholder class to your subclass. Then you can use outlets between
/// the xib file and your subclass.
///
/// You can use subclasses of CBAutoXibView either from code or interface builder.
///
/// - SeeAlso: CBAutoTableViewCell and CBAutoCollectionViewCell to easily use CBAutoXibViews as
///            UITableView and UICollectionView cells.
class CBAutoXibView: CBXibView {

    override class func nibName() -> String? {
        String(describing: self)
    }
}
