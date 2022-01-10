//
//  UIViewExtensions.swift
//  FourSquare
//
//  Created by Vipul Patel on 09/01/22.
//

import UIKit

//MARK: - UIView Propertie(s)
extension UIView {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

//MARK: - UIView IBInspectable(s)
public extension UIView {

    /// `@IBInspectable cornerRadius` property is used to apply corner radius on selected `UIView`.
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
}
