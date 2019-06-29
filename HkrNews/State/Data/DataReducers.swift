//
//  DataReducers.swift
//  HkrNews
//
//  Created by Tim Sawtell on 29/6/19.
//  Copyright © 2019 Tim Sawtell. All rights reserved.
//

import Foundation
import SwiftUI_RowDucks

struct DataReducer: Reducer {
    typealias ResponsibleData = DataState
    
    static func reduce(state: DataState?, action: Action) -> DataState {
        switch action {
            case is RecieveTopStoriesAction:
                let action = (action as! RecieveTopStoriesAction)
                var modified = state!
                action.items.forEach { id in
                    if (modified.stories!["\(id)"] == nil) {
                        modified.stories!["\(id)"] = Item()
                    }
                }
                return modified
        case is ReceiveItemAction:
            let action = (action as! ReceiveItemAction)
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: action.item!, options: []) else {
                break
            }
            let decoder = JSONDecoder()
            if var item = try? decoder.decode(Item.self, from: jsonData) {
                item.isLoaded = true
                var modified = state!
                modified.stories!["\(item.id)"] = item
                return modified
            }
            
            break
            
            default:
                break
        }
        return state ?? DataState(stories: [:])
    }
}
