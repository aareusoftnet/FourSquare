//  LocationPermission.swift
//  FourSquare
//
//  Created by Vipul Patel on 09/01/22.
//

import UIKit

//MARK: - Typealias UserActionBlock
typealias UserActionBlock = (_ uiFor: LocationPermissionUIFor?, _ view: UIView?) -> ()

//MARK: - Enum LocationPermissionUIFor
enum LocationPermissionUIFor {
    case requesting
    case denied
}

//MARK: - Class LocationPermission
class LocationPermission: UIView {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewMapContainer: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var viewBottomLayout: UIView!
    var actionBlock: UserActionBlock?
    var uiFor: LocationPermissionUIFor? {
        didSet {
            prepareUIs()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackground.alpha = 1
    }
}

//MARK: - Initialise
extension LocationPermission {
    
    /// It will show confirm safety action sheet.
    @discardableResult class func showIn(_ view: UIView, uiFor: LocationPermissionUIFor = .requesting, actionBlock: UserActionBlock?) -> LocationPermission {
        let viewLocationPermission = UINib(nibName: "LocationPermission", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LocationPermission
        viewLocationPermission.frame = view.frame
        viewLocationPermission.actionBlock = actionBlock
        viewLocationPermission.uiFor = uiFor
        view.addSubview(viewLocationPermission)
        viewLocationPermission.layoutIfNeeded()
        return viewLocationPermission
    }
    
    func prepareUIs() {
        if let uiFor = uiFor {
            if uiFor == .requesting {
                prepareUIsForRequesting()
            }else{
                prepareUIsForDenied()
            }
        }
    }
    
    func prepareUIsForRequesting() {
        lblTitle.textColor = .appFFFFFF
        lblTitle.text = "~We’d like to know your location.".localized
        lblDescription.textColor = .appC8C8C8
        lblDescription.text = "~By allowing Location Permissions we can show you nearby location venues.".localized
        button.setTitle("~Sure, Ask Me".localized, for: .normal)
        button.setTitle("~Sure, Ask Me".localized, for: .selected)
    }
    
    func prepareUIsForDenied() {
        lblTitle.textColor = .appFFFFFF
        lblTitle.text = "~Uh oh.".localized
        lblDescription.textColor = .appC8C8C8
        lblDescription.text = "~We won’t be able to work properly until you go to your device settings and give us permission to view your location.".localized
        button.setTitle("~Go To Settings".localized, for: .normal)
        button.setTitle("~Go To Settings".localized, for: .selected)
    }
}

//MARK: - IBAction(s)
extension LocationPermission {
    
    @IBAction func onButtonTap(_ sender: UIButton) {
        actionBlock?(uiFor, self)
    }
}
