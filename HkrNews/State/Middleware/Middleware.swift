//
//  Middleware.swift
//  HkrNews
//
//  Created by Tim Sawtell on 29/6/19.
//  Copyright © 2019 Tim Sawtell. All rights reserved.
//

import Foundation
import SwiftUI_RowDucks

class BaseMiddleware: MiddlewareItem {
    func observeStateChange(withBeforeState beforeState: AppState, afterState: AppState, action: Action) {
        // override me
    }
    
    typealias ResponsibleData = AppState
}
