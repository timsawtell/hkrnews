//
//  Item.swift
//  HkrNews
//
//  Created by Tim Sawtell on 28/6/19.
//  Copyright © 2019 Tim Sawtell. All rights reserved.
//

import Foundation

enum RequestType: String {
    case topstories = "topstories"
    case newstories = "newstories"
    case beststories = "beststories"
}

enum ItemType: String {
    case story = "story"
    case job = "job"
    case comment = "comment"
    case poll = "poll"
    case pollot = "pollot"
}

struct Item : Codable, Equatable {
    var id: Int = 0
    var type: String = ""
    var by: String = ""
    var time: Int = 0
    var url: String = ""
    var score: Int = 0
    var title: String = ""
    // optionals
    var parent: Int?
    var poll: Int?
    var kids: [Int]?
    var parts: Int?
    var descendants: Int?
    var isLoaded: Bool? = false
    var deleted: Bool? = false
    var dead: Bool? = false
}
