//
//  RandomResult.swift
//  WordOfTheDay
//
//  Created by Shafali Gupta on 4/13/22.
//

import Foundation

class ResultArray: Codable {
  var results = [RandomResult]()
}

class RandomResult: Codable {
    var word: String? = ""
}
