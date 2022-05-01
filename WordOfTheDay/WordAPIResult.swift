//
//  WordAPIResult.swift
//  WordOfTheDay
//
//  Created by Shafali Gupta on 4/14/22.
//

import Foundation

class WordAPIResult: Codable {
  var word: String? = ""
  var results: [expandedResult]?
    var syllables: expandedSyllables?
//    var pronunciation: Any?

//  enum CodingKeys: String, CodingKey {
//    case imageSmall = "artworkUrl60"
//    case imageLarge = "artworkUrl100"
//    case itemGenre = "primaryGenreName"
//    case bookGenre = "genres"
//    case itemPrice = "price"
//    case kind, artistName, currency
//    case trackName, trackPrice, trackViewUrl
//    case collectionName, collectionViewUrl, collectionPrice
//  }
}

class expandedResult: Codable {
    var definition: String?
    var partOfSpeech: String?
    var synonyms: [String]?
    var typeOf: [String]?
    var hasTypes : [String]?
    var derivation : [String]?
    var examples : [String]?
//    enum CodingKeys: String, CodingKey{
//        case definition: "definition"
//    }
}

class expandedSyllables: Codable {
    var count: Int?
    var list: [String]?
}
//class expandedPronunciation: Codable {
//    var all: String?
//    enum CodingKeys: String, CodingKey {
//        case all = "allPron"
//
//    }
//}

//"definition":"a representative form or pattern"
//"partOfSpeech":"noun"
//"synonyms":[...]1 item
//"typeOf":[...]3 items
//"hasTypes":[...]16 items
//"derivation":[...]1 item
//"examples":[...]1 item
