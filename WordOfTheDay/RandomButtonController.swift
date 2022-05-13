//
//  RandomButtonController.swift
//  WordOfTheDay
//
//  Created by Shafali Gupta on 5/11/22.
//

import Foundation
import UIKit

protocol RandomFavoriteDelegate: AnyObject{
    func randomButtonTapped(favWord: String)
}
class RandomBarButtonItem : UIBarButtonItem {
    weak var delegate: RandomFavoriteDelegate?
    let context = (UIApplication.shared.delegate as! AppDelegate) .persistentContainer.viewContext
    override init()     {
        super.init()
    }

    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
            self.action = #selector(RandomBarButtonItem.didTapButton)
        }

    @objc func didTapButton() {
        var word: String
        do{
            var FavoList = [FavoritedWord]()
            FavoList = try context.fetch(FavoritedWord.fetchRequest())
            word = (FavoList.randomElement()!).name!
            delegate?.randomButtonTapped(favWord: word)
        }
        catch{
            print("Could not load Favorites")
        }
    }
}

