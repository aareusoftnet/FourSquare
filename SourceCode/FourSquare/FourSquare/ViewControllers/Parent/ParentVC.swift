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
