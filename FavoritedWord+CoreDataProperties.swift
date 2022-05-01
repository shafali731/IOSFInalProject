//
//  FavoritedWord+CoreDataProperties.swift
//  WordOfTheDay
//
//  Created by Shafali Gupta on 4/30/22.
//
//

import Foundation
import CoreData


extension FavoritedWord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritedWord> {
        return NSFetchRequest<FavoritedWord>(entityName: "FavoritedWord")
    }

    @NSManaged public var name: String?

}

extension FavoritedWord : Identifiable {

}
