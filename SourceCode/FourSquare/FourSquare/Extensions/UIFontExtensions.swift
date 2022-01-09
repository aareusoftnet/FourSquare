//
//  UIFontExtensions.swift
//  FourSquare
//
//  Created by Vipul Patel on 09/01/22.
//

import UIKit

//MARK: UIFont(s)
extension UIFont {
    
    public static func proximaBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-Bold", size: size)!
    }
    
    public static func proximaRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-Regular", size: size)!
    }
    
    public static func proximaSemiBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-SemiBold", size: size)!
    }
    
    public static func proximaNovaBlack(_ size: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-Black", size: size)!
    }
    
    public static func proximaNovaLight(_ size: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-Light", size: size)!
    }
}
