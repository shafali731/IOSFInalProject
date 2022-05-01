//
//  RandomResult.swift
//  WordOfTheDay
//
//  Created by Shafali Gupta on 4/13/22.
//

import Foundation

class ResultArray: Codable {
//  var resultCount = 0
  var results = [RandomResult]()
}

class RandomResult: Codable {
    var word: String? = ""
//    var pronunciation: [String]?
//  var trackName: String? = ""
//  var kind: String? = ""
//  var trackPrice: Double? = 0.0
//  var currency = ""
//  var imageSmall = ""
//  var imageLarge = ""
//  var trackViewUrl: String?
//  var collectionName: String?
//  var collectionViewUrl: String?
//  var collectionPrice: Double?
//  var itemPrice: Double?
//  var itemGenre: String?
//  var bookGenre: [String]?

//  enum CodingKeys: String, CodingKey {
//      case word
////    case imageSmall = "artworkUrl60"
////    case imageLarge = "artworkUrl100"
////    case itemGenre = "primaryGenreName"
////    case bookGenre = "genres"
////    case itemPrice = "price"
////    case kind, artistName, currency
////    case trackName, trackPrice, trackViewUrl
////    case collectionName, collectionViewUrl, collectionPrice
//  }
}
