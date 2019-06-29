//
//  State.swift
//  HkrNews
//
//  Created by Tim Sawtell on 28/6/19.
//  Copyright © 2019 Tim Sawtell. All rights reserved.
//

import Foundation

struct StoriesUI: Equatable {
    var storiesListUpdating: Bool
}

struct UIState: Equatable {
    var stories: StoriesUI
}

struct DataState: Equatable {
    var stories: [String: Item]?
}

struct AppState: Equatable {
    var ui: UIState
    var data: DataState
}

