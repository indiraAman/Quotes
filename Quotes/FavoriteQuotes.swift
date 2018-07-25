//
//  FavoriteQuotes.swift
//  Quotes
//
//  Created by Indira on 24.07.2018.
//  Copyright © 2018 Indira. All rights reserved.
//

import UIKit
import CoreData

class FavoriteQuotes: NSManagedObject {

    @NSManaged var favQuoteAuthor: String
    @NSManaged var favQuoteText: String
}
