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
    var objVenue: Venue? {
        didSet {
            prepareUIs()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func prepareUIs() {
        if let objVenue = objVenue {
            viewCategory.backgroundColor = FIXED_COLORS.randomElement()
            lblCategory.text = objVenue.category.name.isEmpty ? "--" : objVenue.category.name
            lblDistance.text = objVenue.displayDistance
            lblName.text = objVenue.name
            lblAddress.text = objVenue.location.displayAddress
        }
    }
}
