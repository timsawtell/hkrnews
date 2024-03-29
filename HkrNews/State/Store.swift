//
//  Store.swift
//  HkrNews
//
//  Created by Tim Sawtell on 28/6/19.
//  Copyright © 2019 Tim Sawtell. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftUI_RowDucks
import Combine

/// Force the property to conform to the Equatable protocol
@propertyDelegate struct SwiftUIEquatable<Value: Equatable> {
    public var value: Value!
}

/// Used when setting up the state so that the default values are applied
struct InitAction: Action {}

/// The top most `Reducer` in the app. For every action that is dispatched, this is the reducer that is run.
/// This reducer will shard off responsibility for it's various sections of the object graph to the
/// appropriate reducer, i.e for the `UI` section of `AppState`, it uses the resulting value of the
/// `UIReducer`'s reduce function.
///
/// Reducers are composable (by coincidence, not by language) and can call other reducers.
///
/// This gives the programmer the ability to shard off whole sections of the app `State` to separate swift
/// files, maintained by different programmers, if you happen to work in a team.
fileprivate struct AppMainReducer : Reducer {
    
    typealias ResponsibleData = AppState
    
    static func reduce(state: AppState?, action: Action) -> AppState {
        return AppState(
            ui: UIReducer.reduce(state: state?.ui, action: action),
            data: DataReducer.reduce(state: state?.data, action: action)
        )
    }
}

final class Store : BindableObject {
    /// Implement the `BindableObject` protocol
    var didChange = PassthroughSubject<AppState, Never>()
    
    /// The whole app's single `state` entity
    @SwiftUIEquatable fileprivate(set) var state: AppState
    
    fileprivate var middleware: [BaseMiddleware]?
    
    init() {
        self.state = AppMainReducer.reduce(state: nil, action: InitAction())
    }
    
    convenience init(middleware: [BaseMiddleware]) {
        self.init()
        self.middleware = middleware
    }
    
    /// Grab a copy of `state`. Run your main reducer with this `action` and then
    /// compare the new `state` against the old `state`. If there is a difference,
    /// tell SwiftUI that it needs to layout its views again via the `BindableObject`
    /// `didChange` function.
    func dispatch(action: Action) {
        
        let beforeState = state
        state = AppMainReducer.reduce(state: state, action: action)
        
        // let all the middleware execute their handlers
        middleware?.forEach { middleware in
            middleware.observeStateChange(withBeforeState: beforeState, afterState: state, action: action)
        }
        
        if state != beforeState {
            // found that the state is different after that Action, notify subscribers
            didChange.send(state)
        }
    }
    
    /// Run the `asyncAction`'s closure and pass in `self`, so that the closure can
    /// then call `dispatch` on self (to actually make changes to the state)
    func dispatch<T: AsyncAction>(asyncAction: T) {
        asyncAction.closure(self as! T.MyStore)
    }
}

var storeInstance = Store()
