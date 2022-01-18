//
//  Category.swift
//  FourSquare
//
//  Created by Vipul Patel on 17/01/22.
//

import CoreData

//MARK: - Class Category
class Category: NSManagedObject, ParentMO {
    @NSManaged var id: Int64
    @NSManaged var name: String
}

//MARK: Initialize
extension Category {
    
    func initWith(_ dictionary: NSDictionary) {
        id = dictionary.getInt64Value(forKey: "id")
        name = dictionary.getStringValue(forKey: "name")
    }
}
