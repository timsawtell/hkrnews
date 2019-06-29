//
//  UIReducers.swift
//  HkrNews
//
//  Created by Tim Sawtell on 29/6/19.
//  Copyright © 2019 Tim Sawtell. All rights reserved.
//

import Foundation
import SwiftUI_RowDucks

struct UIReducer: Reducer {
    typealias ResponsibleData = UIState
    
    static func reduce(state: UIState?, action: Action) -> UIState {
        return state ?? UIState(stories: StoriesUIReducer.reduce(state: nil, action: InitAction()))
    }
}

struct StoriesUIReducer: Reducer {
    typealias ResponsibleData = StoriesUI
    
    static func reduce(state: StoriesUI?, action: Action) -> StoriesUI {
        switch action {
        case is GetTopStoriesAction:
            var modified = state!
            modified.storiesListUpdating = true
            return modified
        default:
            break
        }
        return state ?? StoriesUI(storiesListUpdating: false)
    }
    
}
