//
//  EmptyList.swift
//  FourSquare
//
//  Created by Vipul Patel on 09/01/22.
//

import UIKit

//MARK: - Protocol UserActionDelegate
protocol UserActionDelegate: AnyObject {
    func didTapOn(_ text: String?, cell: UITableViewCell?)
}

//MARK: - Class EmptyList
class EmptyList: UITableViewCell {
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var button: UIButton!
    weak var delegate: UserActionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
    }
}

//MARK: - UIRelated(s)
extension EmptyList {
    
    func prepareUIs() {
        if NetworkMonitor.shared.isReachable {
            prepareEmptlyListUIs()
        }else{
            prepareNoInternetConnectionUIs()
        }
    }
    
    func prepareEmptlyListUIs() {
        lblTitle.textColor = .appFFFFFF
        lblTitle.text = "~Sorry.".localized
        lblDescription.textColor = .appC8C8C8
        lblDescription.text = "~We won’t be able to find any venues near by your current location, please try after sometimes when we get any venues near by your current location.".localized
        button.setTitle("~Try again".localized, for: .normal)
        button.setTitle("~Try again".localized, for: .selected)
    }
    
    func prepareNoInternetConnectionUIs() {
        lblTitle.textColor = .appFFFFFF
        lblTitle.text = "~No internet connection".localized
        lblDescription.textColor = .appC8C8C8
        lblDescription.text = "~ It seems to be you have no internet connection, please try to check your mobile data or wifi settings.".localized
        button.setTitle("~Try again".localized, for: .normal)
        button.setTitle("~Try again".localized, for: .selected)
    }
}

//MARK: - IBAction(s)
extension EmptyList {
    
    @IBAction func onTryAgainTap(_ sender: UIButton) {
        delegate?.didTapOn("~Try again".localized, cell: self)
    }
}
