//
//  DashboardVC.swift
//  FourSquare
//
//  Created by Vipul Patel on 09/01/22.
//

import UIKit

//MARK: - Class DashboardVC
class DashboardVC: ParentVC {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var closestContainer: UIView!
    @IBOutlet weak var aboutUsContainer: UIView!    
}

//MARK: UIViewController method(s)
extension DashboardVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
    }
}

//MARK: UIRelated(s)
extension DashboardVC {
    
    private func prepareUIs() {
        updateGlobalUIs()
        updateUIs(0)
    }
    
    private func updateGlobalUIs() {
        segmentedControl.setTitle("~Closest venue".localized, forSegmentAt:  0)
        segmentedControl.setTitle("~About us".localized, forSegmentAt:  1)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.appC8C8C8, NSAttributedString.Key.font: UIFont.proximaBold(14)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.appFFFFFF, NSAttributedString.Key.font: UIFont.proximaBold(14)], for: .selected)
    }
    
    private func updateUIs(_ selectedIndex: Int) {
        if selectedIndex == 0 {
            closestContainer.isHidden = false
            aboutUsContainer.isHidden = true
        }else{
            closestContainer.isHidden = true
            aboutUsContainer.isHidden = false
        }
    }
}

//MARK: IBAction(s)
extension DashboardVC {
    
    @IBAction func didSegmentTap(_ sender: UISegmentedControl) {
        updateUIs(sender.selectedSegmentIndex)
    }
}
