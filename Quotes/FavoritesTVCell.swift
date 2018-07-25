//
//  FavoritesTVCell.swift
//  Quotes
//
//  Created by Indira on 24.07.2018.
//  Copyright © 2018 Indira. All rights reserved.
//

import UIKit

class FavoritesTVCell: UITableViewCell {
    
    @IBOutlet var quote: UILabel!
    @IBOutlet var author: UILabel!
    
    var item: Favorites! {
        didSet {
            quote.text = item.favQuoteText
            author.text = item.favQuoteAuthor
        }
    }
}
