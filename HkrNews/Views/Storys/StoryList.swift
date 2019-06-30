//
//  SwiftUIView.swift
//  HkrNews
//
//  Created by Tim Sawtell on 30/6/19.
//  Copyright © 2019 Tim Sawtell. All rights reserved.
//

import SwiftUI
import Combine

struct StoryList : View {
    
    @ObjectBinding var provider = StoryListViewModelMapper()
    
    var body: some View {
        List(provider.viewModel.stories.identified(by: \.id)) { story in
            StoryCell(item: story)
        }
    }
}

#if DEBUG
struct SwiftUIView_Previews : PreviewProvider {
    static var previews: some View {
        StoryList()
    }
}
#endif

/// This is the view model that this one `View` cares about.
struct StoryListViewModel: Equatable {
    var stories: [Item]
}

/// Turn the global state object into a single View Model publisher
class StoryListViewModelMapper : BindableObject {
    var viewModel = StoryListViewModel(stories: [])
    var didChange = PassthroughSubject<StoryListViewModel, Never>()
    var storeSubscription: Subscription?
    var store: Store {
        return storeInstance
    }
    
    init() {
        // make this instance _care_ about the store changing state by subscribing
        // to it's `PassthroughSubject`
        store.didChange.subscribe(self)
        // establish the view model based on the current app state
        mapStateToViewModel(store.state)
    }
}

extension StoryListViewModelMapper: Subscriber {
    typealias Input = AppState
    typealias Failure = Never
    
    /// Turn the whole state object into a tiny little view model, and then
    /// publish a change to any of _my_ subscribers via my own `didChange`
    /// call
    func receive(_ input: AppState) -> Subscribers.Demand {
        mapStateToViewModel(input)
        return .unlimited
    }
    
    func mapStateToViewModel(_ input: AppState) {
        let previousViewModel = viewModel
        let items = input.data.stories?.values.filter({ item in
            return (item.isLoaded ?? false)
        }) ?? []
        viewModel = StoryListViewModel(stories: items)
        if previousViewModel != viewModel {
            didChange.send(viewModel)
        }
    }
    
    func receive(subscription: Subscription) {
        storeSubscription = subscription
        storeSubscription?.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) { }
}
