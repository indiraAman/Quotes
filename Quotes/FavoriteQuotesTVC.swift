//
//  FavoriteQuotesTVC.swift
//  Quotes
//
//  Created by Indira on 24.07.2018.
//  Copyright © 2018 Indira. All rights reserved.
//

import UIKit
import CoreData

class FavoriteQuotesTVC: UITableViewController {
    
    var favorites = [Favorites]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        
        do{
            let favorites = try PersistenceService.context.fetch(fetchRequest)
            self.favorites = favorites
            self.tableView.reloadData()
            
        } catch{
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
      
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavoritesTVCell
        
        let item : Favorites
        item = favorites[indexPath.row]
        cell.item = self.favorites[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height: CGFloat = 200.0
        return height
    }
  

}
