//
//  ViewController.swift
//  Цитаты
//
//  Created by Indira on 23.07.2018.
//  Copyright © 2018 Indira. All rights reserved.
//

import UIKit
import SQLite
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var autorNameLbl: UILabel!
    
    @IBOutlet weak var papyrusBottomImg: UIImageView!
    @IBOutlet weak var papyrusTopImg: UIImageView!
    @IBOutlet weak var papyrusBackgr: UIImageView!
    
    @IBOutlet weak var stampImg: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var favoriteListBtn: UIButton!
    
    
    @IBOutlet var tapView: UIView!
    
    //var favoriteQuotes: FavoriteQuotes!
    
    var quoteText: Quotes?
    var quotes = [Row]()
    
    var favoriteQ = [Favorites]()
    
    var currentQuotes = 0
    
    var dataBase: Connection!
    
    let wisdomTable = Table("wisdom")
    let id = Expression<Int>("ID")
    let autorName = Expression<String>("AutorName")
    let text = Expression<String>("Text")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animation(true)
        copyDatabaseIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func animation(_ animated: Bool) {
        //---------papyrus animation-------
        UIView.animate(withDuration: 1.5, delay: 1.0, options: .curveEaseOut, animations: {
            
            self.papyrusTopImg.center = CGPoint(x: 185, y: 85)
            var papyrusTopFrame = self.papyrusTopImg.frame
            papyrusTopFrame.origin.y -= papyrusTopFrame.size.height
            
            self.papyrusBottomImg.center = CGPoint(x: 185, y: 510)
            var papyrusBottomFrame = self.papyrusBottomImg.frame
            papyrusBottomFrame.origin.y += papyrusBottomFrame.size.height
            
            self.papyrusBottomImg.frame = papyrusBottomFrame
            self.papyrusBottomImg.frame = papyrusBottomFrame
            
            let screenSize: CGRect = UIScreen.main.bounds
            self.papyrusBackgr.frame = CGRect(x: 21, y: 85, width: 333, height: screenSize.height * 0.75)
            
            
        }, completion: { finished in
            print("papyrus")
        })
        self.textView.alpha = 0
        self.autorNameLbl.alpha = 0
        self.likeBtn.alpha = 0
        self.stampImg.alpha = 0
        //            self.searchBtn.alpha = 0
        //            self.favoriteListBtn.alpha = 0
        
        
        UIView.animate(withDuration: 2.0, delay: 1.0, animations: {
            
            self.textView.contentOffset = CGPoint.zero
            self.textView.alpha = 1
            self.autorNameLbl.alpha = 1
            self.likeBtn.alpha = 1
            self.stampImg.alpha = 1
            //            self.searchBtn.alpha = 1
            //            self.favoriteListBtn.alpha = 1
            
        })
    }
    
    func copyDatabaseIfNeeded() {
        // Move database file from bundle to documents folder
        
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        
        guard documentsUrl.count != 0 else {
            return // Could not find documents URL
        }
        
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("database.db")
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent("database.db")
            
            do {
                try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
                
                let dataBase = try Connection(finalDatabaseURL.path)
                self.dataBase = dataBase
                self.listOfText()
                
                
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
            
        } else {
            
            do {
                
                let dataBase = try Connection(finalDatabaseURL.path)
                self.dataBase = dataBase
                self.listOfText()
                
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
    }
    
  
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake {
            print("SHAKE")
            self.animation(true)
            
            let index = Int(arc4random_uniform(UInt32(quotes.count)))
            let wisd = quotes[index]
            self.quoteText = Quotes.init(quoteText: wisd[self.text], quoteAutor: wisd[self.autorName])
            self.loadView2()
            
            if (currentQuotes == quotes.count-1) {
                currentQuotes = 0
            } else {
                currentQuotes += 1
            }
        }
    }
    
    
    func listOfText () {
        
        do {
            let wisdoM = try self.dataBase.prepare(self.wisdomTable)
            self.quotes = wisdoM.reversed()
            //let wisd = quotes.first
            let index = Int(arc4random_uniform(UInt32(quotes.count)))
            let wisd = quotes[index]
            self.quoteText = Quotes.init(quoteText: wisd[self.text], quoteAutor: wisd[self.autorName])
            
            self.loadView2()
        } catch{
            print(error)
        }
    }
    
    
    func loadView2() {
        
        DispatchQueue.main.async {
            self._loadView2()
        }
    }
    
    
    func _loadView2() {
        
        textView.text = quoteText?.quoteText
        autorNameLbl.text = quoteText?.quoteAutor
    }

    @IBAction func likeBtnClicked(_ sender: UIButton) {
        
        print("Like button clicked")
        let favoriteQuote = Favorites(context: PersistenceService.context)
        favoriteQuote.favQuoteAuthor = quoteText?.quoteAutor
        favoriteQuote.favQuoteText = quoteText?.quoteText
        PersistenceService.saveContext()
        self.favoriteQ.append(favoriteQuote)
    }
    
    
    
}

