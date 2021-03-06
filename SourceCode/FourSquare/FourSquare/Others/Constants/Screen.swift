//
//  Screen.swift
//  FourSquare
//
//  Created by Vipul Patel on 17/01/22.
//

import UIKit

//MARK: - Struct Screen
public struct Screen {
    fileprivate static let SIZE: CGSize = UIScreen.main.bounds.size
    public static let WIDTH: CGFloat = SIZE.width
    public static let HEIGHT: CGFloat = SIZE.height
    public static let safeAreaInsets: UIEdgeInsets = SceneDelegate.shared!.window!.safeAreaInsets
    public static var widthRatio: CGFloat {
        return WIDTH/375
    }
    public static var heightRatio: CGFloat {
        return HEIGHT/667
    }
}
