//
//  Favorites+CoreDataProperties.swift
//  
//
//  Created by Indira on 24.07.2018.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var favQuoteAuthor: String?
    @NSManaged public var favQuoteText: String?

}
