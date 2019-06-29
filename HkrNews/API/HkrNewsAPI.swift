//
//  HkrNewsAPI.swift
//  HkrNews
//
//  Created by Tim Sawtell on 29/6/19.
//  Copyright © 2019 Tim Sawtell. All rights reserved.
//

import Foundation

typealias TopPostsResponseHandler = ([Int]?, Error?) -> Void
typealias GetItemResponseHandler = (Any?, Error?) -> Void

fileprivate let instance = HkrNewsAPI()

class HkrNewsAPI {
    class var shared: HkrNewsAPI {
        return instance
    }
    
    var baseURL = "https://hacker-news.firebaseio.com/v0"
    
    func getTopPostsfor(type: RequestType, handler: @escaping TopPostsResponseHandler) {
        let fullURI = "\(baseURL)/\(type.rawValue).json"
        let url = URL(string: fullURI)!
        
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let err = error {
                handler(nil, err)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [Int]
                handler(json, nil)
            } catch let err {
                handler(nil, err)
                return
            }
            
        }
        task.resume()
    }
    
    func getItem(itemId: String, handler: @escaping GetItemResponseHandler) {
        let fullURI = "\(baseURL)/item/\(itemId).json"
        let url = URL(string: fullURI)!
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let err = error {
                handler(nil, err)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                handler(json, nil)
            } catch let err {
                handler(nil, err)
                return
            }
            
        }
        task.resume()
    }
}

