//
//  CBXibView.swift
//  ProjectPurple
//
//  Created by Pinto Diaz, Roger on 4/7/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import UIKit

/// A view that loads its content from a xib file.
/// The view contents are properly previewed in interface builder.
/// Reference: https://medium.com/zenchef-tech-and-product/how-to-visualize-reusable-xibs-in-storyboards-using-ibdesignable-c0488c7f525d
/// - SeeAlso : CBAutoXibView
@IBDesignable
class CBXibView: UIView {

    // MARK: - Public interface

    // The root view of the loaded xib is assigned to this property.
    public var contentView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Override in subclasses

    /// This method is called after the init of the class.
    ///
    /// This is a convenience method so you don't have to put your custom init code in both
    /// init(frame:) and init(coder:).
    ///
    /// - Parameter contentView: A reference to the root view of the loaded xib.
    func setupContentView(_ contentView: UIView) {
    }

    /// Return the name of the xib file to load.
    ///
    /// - Returns: The name of the xib file to load.
    internal class func nibName() -> String? {
        nil
    }

    // MARK: - Implementation
    
    private func setupView() {
        guard let view = loadViewFromNib() else {
            let typeString = String(describing: type(of: self))
            fatalError(
                "Unspecified nib file for object of class " + typeString + ". " +
                "To fix this set a defaultValue to " + typeString + " nibName property"
            )
        }

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        setupContentView(view)
        contentView = view
    }
    
    private func loadViewFromNib() -> UIView? {
        guard let nibName = type(of: self).nibName() else {
            return nil
        }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    /// This method is only called by Xcode to render a preview of the view in interface builder.
    /// You never need to call this method.
    override func prepareForInterfaceBuilder() {
        setupView()
        contentView?.prepareForInterfaceBuilder()
        super.prepareForInterfaceBuilder()
    }
}
