//
//  VenueList.swift
//  FourSquare
//
//  Created by Vipul Patel on 09/01/22.
//

import UIKit

class VenueList: UITableViewCell {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
