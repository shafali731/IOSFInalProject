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
}

class expandedResult: Codable {
    var definition: String?
    var partOfSpeech: String?
    var synonyms: [String]?
    var typeOf: [String]?
    var hasTypes : [String]?
    var derivation : [String]?
    var examples : [String]?
}

class expandedSyllables: Codable {
    var count: Int?
    var list: [String]?
}
