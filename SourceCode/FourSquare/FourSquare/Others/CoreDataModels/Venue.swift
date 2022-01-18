//
//  Venue.swift
//  FourSquare
//
//  Created by Vipul Patel on 17/01/22.
//

import CoreData

//MARK: - Class Venue
class Venue: NSManagedObject, ParentMO {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var distance: Int64
    @NSManaged var location: Location
    @NSManaged var category: Category
    
    var displayDistance: String {
        if distance > 1000 {
            return String(format: "%.2f", Float(Float(distance)/Float(1000))) + "~ km away".localized
        }else{
            return distance.description + "~ meters away".localized
        }
    }
}

//MARK: Initialize
extension Venue {
    
    func initWith(_ dictionary: NSDictionary) {
        id = dictionary.getStringValue(forKey: "fsq_id")
        name = dictionary.getStringValue(forKey: "name")
        distance = dictionary.getInt64Value(forKey: "distance")
        if let arrOfCategories = dictionary["categories"] as? [NSDictionary],
            let dictCategory = arrOfCategories.first {
            let categoryID = dictCategory.getStringValue(forKey: "id")
            let objCategory = Category.addUpdateEntity(key: "id", value: categoryID)
            objCategory.initWith(dictCategory)
            category = objCategory
        }
        if let dictLocation = dictionary["location"] as? NSDictionary {
            let venueID = dictionary.getStringValue(forKey: "fsq_id")
            let objLocation = Location.addUpdateEntity(key: "id", value: venueID)
            objLocation.initWith(venueID, dictionary: dictLocation)
            location = objLocation
        }
    }
}
