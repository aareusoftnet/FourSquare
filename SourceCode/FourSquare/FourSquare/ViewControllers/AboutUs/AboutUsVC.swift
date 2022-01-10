//
//  AboutUsVC.swift
//  FourSquare
//
//  Created by Vipul Patel on 09/01/22.
//

import UIKit

//MARK: - Class AboutUsVC
class AboutUsVC: ParentVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: IBAction(s)
extension AboutUsVC {
    
    @IBAction func onContactNumberTap(_ sender: UIButton) {
        if let url = URL(string: "tel://+919016813081"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func onEmailTap(_ sender: UIButton) {
        if let url = URL(string: "mailto://vipul.patel251@gmail.com"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
