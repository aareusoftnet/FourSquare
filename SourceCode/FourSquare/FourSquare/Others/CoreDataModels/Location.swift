//
//  Location.swift
//  FourSquare
//
//  Created by Vipul Patel on 17/01/22.
//

import CoreData

//MARK: - Class Location
class Location: NSManagedObject, ParentMO {
    @NSManaged var id: String
    @NSManaged var address: String
    @NSManaged var crossStreet: String
    @NSManaged var locality: String
    @NSManaged var region: String
    @NSManaged var country: String
    @NSManaged var postcode: String
    
    var displayAddress: String {
        var fullAddress = ""
        if address.isEmpty == false {
            fullAddress += address
        }
        if crossStreet.isEmpty == false {
            fullAddress += crossStreet + ", "
        }
        if locality.isEmpty == false {
            fullAddress += locality + ", "
        }
        if region.isEmpty == false {
            fullAddress += region + ", "
        }
        if country.isEmpty == false {
            fullAddress += country + ", "
        }
        if postcode.isEmpty == false {
            fullAddress += "- " + postcode
        }
        return fullAddress
    }
}

//MARK: Initialize
extension Location {
    
    func initWith(_ vanueID: String, dictionary: NSDictionary) {
        id = vanueID
        address = dictionary.getStringValue(forKey: "address")
        region = dictionary.getStringValue(forKey: "region")
        country = dictionary.getStringValue(forKey: "country")
        crossStreet = dictionary.getStringValue(forKey: "cross_street")
        locality = dictionary.getStringValue(forKey: "locality")
        postcode = dictionary.getStringValue(forKey: "postcode")
    }
}
