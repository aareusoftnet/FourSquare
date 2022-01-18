//
//  ParentVC.swift
//  FourSquare
//
//  Created by Vipul Patel on 09/01/22.
//

import UIKit

//MARK: - Class ParentVC
class ParentVC: UIViewController {
    @IBOutlet var viewTopLayoutMargin: UIView?
    @IBOutlet var viewNavigationBar: UIView?
    @IBOutlet var viewBottomBar: UIView?
    @IBOutlet var viewBottomLayoutMargin: UIView?
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?

    lazy internal var largeActivityIndicator : UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = UIColor.white
        return activity
    }()

    lazy internal var mediumActivityIndicator : UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.color = UIColor.white
        return activity
    }()

    deinit{
        print("Deallocated: \(self.classForCoder)")
    }
}

//MARK: UIViewController method(s) & Properties
extension ParentVC {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Allocated: \(self.classForCoder)")
        constraintUpdate()
    }
}

//MARK: UIRelated
extension ParentVC {
    
    //This will update constaints and shrunk it as device screen goes lower.
    func constraintUpdate() {
        //Horizontal constraings
        if let hConts = horizontalConstraints {
            for const in hConts {
                let v1 = const.constant
                let v2 = v1 * Screen.widthRatio
                const.constant = v2
            }
        }
        //Verticle constraings
        if let vConst = verticalConstraints {
            for const in vConst {
                let v1 = const.constant
                let v2 = v1 * Screen.heightRatio
                const.constant = v2
            }
        }
    }
}


//MARK: - UIActivityIndicator(s)
extension ParentVC {
    
    func showIndicatorInCenter(_ color: UIColor = .white) {
        largeActivityIndicator.color = color
        view.addSubview(largeActivityIndicator)
        let xConstraint = NSLayoutConstraint(item: largeActivityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: largeActivityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        largeActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([xConstraint, yConstraint])
        largeActivityIndicator.alpha = 0.0
        view.isUserInteractionEnabled = false
        largeActivityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.largeActivityIndicator.alpha = 1.0
        }
    }

    func hideIndicatorFromCenter() {
        view.isUserInteractionEnabled = true
        largeActivityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2, animations: {
            self.largeActivityIndicator.alpha = 0.0
        }) { (isFinish) in
            self.largeActivityIndicator.removeFromSuperview()
        }
    }

    
    func showIndicatorIn(_ container: UIView, control: UIView, color: UIColor = .white) {
        mediumActivityIndicator.color = color
        container.addSubview(mediumActivityIndicator)
        let xConstraint = NSLayoutConstraint(item: mediumActivityIndicator, attribute: .centerX, relatedBy: .equal, toItem: container, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: mediumActivityIndicator, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 0)
        mediumActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([xConstraint, yConstraint])
        mediumActivityIndicator.alpha = 0.0
        view.layoutIfNeeded()
        view.isUserInteractionEnabled = false
        mediumActivityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.mediumActivityIndicator.alpha = 1.0
            control.alpha = 0.0
        }
    }
    
    func hideIndicatorFrom(_ container: UIView, control: UIView) {
        view.isUserInteractionEnabled = true
        mediumActivityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2, animations: {
            self.mediumActivityIndicator.alpha = 0.0
            control.alpha = 1.0
        }) { (isFinish) in
            self.mediumActivityIndicator.removeFromSuperview()
        }
    }
}
