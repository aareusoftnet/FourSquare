//
//  ValidationToast.swift
//  FourSquare
//
//  Created by Vipul Patel on 18/01/22.
//

import UIKit

//MARK: - Enum ValidationToastType
enum ValidationToastType {
    case error
    case warning
    case success
}

//MARK: - Class ValidationToast
class ValidationToast {
    
    static var shared = ValidationToast()
    
    init() {}

    @discardableResult func showToast(_ message: String, type: ValidationToastType = .error, font: UIFont = .proximaBold(12), color: UIColor = .appFF416F, autoHide: Bool = true) -> ValidationToastView {
        let toast = UINib(nibName: "ValidationToastView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ValidationToastView
        let messageHeight = message.height(withConstrainedWidth: Screen.WIDTH - 16, font: font)
        let height: CGFloat = Screen.safeAreaInsets.top + messageHeight + 45
        toast.animatingViewBottomConstraint.constant = height
        toast.animatingView.backgroundColor = color
        toast.setToast(message, font: font)
        SceneDelegate.shared?.window?.addSubview(toast)
        var newFrame = CGRect.zero
        newFrame = UIScreen.main.bounds
        newFrame.size.height = height
        toast.frame = newFrame
        toast.layoutIfNeeded()
        toast.animateIn(duration: 0.2, delay: 0.2, completion: { () -> () in
            if autoHide {
                toast.animateOut(duration: 0.2, delay: 3.0, completion: { () -> () in
                    toast.removeFromSuperview()
                })
            }
        })
        return toast
    }
}

//MARK: - Class ValidationToastView
class ValidationToastView: UIView {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var animatingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var animatingView: UIView!
    
    deinit {
        print("ValidationToastView Deallocated")
    }
    
    func setToast(_ message: String, font: UIFont) {
        messageLabel.text = message
    }
    
    func setToast(_ message: NSAttributedString, type: ValidationToastType) {
        messageLabel.attributedText = message
        switch type {
        case .error:
            animatingView.backgroundColor = .appFF416F
        case .warning:
            animatingView.backgroundColor = .appFFD100
        case .success:
            animatingView.backgroundColor = .app01F991
        }
    }

    func animateIn(duration: TimeInterval, delay: TimeInterval, completion: (() -> ())?) {
        animatingViewBottomConstraint.constant = 0
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            self.layoutIfNeeded()
            }) { (completed) -> Void in
                completion?()
        }
    }

    func animateOut(duration: TimeInterval, delay: TimeInterval, completion: (() -> ())?) {
        animatingViewBottomConstraint.constant = frame.size.height
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            self.layoutIfNeeded()
            }) { (completed) -> Void in
                completion?()
        }
    }
}
