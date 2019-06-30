//
//  DataActions.swift
//  HkrNews
//
//  Created by Tim Sawtell on 29/6/19.
//  Copyright © 2019 Tim Sawtell. All rights reserved.
//

import Foundation
import SwiftUI_RowDucks

struct GetTopStoriesAction : AsyncAction {
    typealias MyStore = Store
    
    var closure: (Store) -> Void = { store in
        HkrNewsAPI.shared.getTopPostsfor(type: .topstories) { (ids: [Int]?, error: Error?) in
            guard let ids = ids else {
                return
            }
            DispatchQueue.main.async {
                store.dispatch(action: RecieveTopStoriesAction(items: ids))
                store.dispatch(asyncAction: GetDetailsForStories())
            }
        }
    }
}

struct GetDetailsForStories : AsyncAction {
    var limit = 20
    typealias MyStore = Store
    
    var closure: (Store) -> Void = { store in
        // find the `limit` `Item`s that are not loaded yet
        let filteredIds = store.state.data.stories?.filter({ (key: String, value: Item) -> Bool in
            return !(value.isLoaded ?? false)
        }).compactMap { $0 }.prefix(20)
        
        // get the details for each of these "unloaded" items
        filteredIds?.forEach({ (arg: (key: String, value: Item)) in
            HkrNewsAPI.shared.getItem(itemId: arg.key) { (response: Any?, error: Error?) in
                if let anItem = response {
                    DispatchQueue.main.async {
                        store.dispatch(action: ReceiveItemAction(item: anItem))
                    }
                }
            }
        })
    }
}

struct RecieveTopStoriesAction : Action {
    var items: [Int]
}

struct ReceiveItemAction : Action {
    var item: Any?
}
