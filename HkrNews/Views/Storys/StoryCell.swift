//
//  StoryCell.swift
//  HkrNews
//
//  Created by Tim Sawtell on 30/6/19.
//  Copyright © 2019 Tim Sawtell. All rights reserved.
//

import SwiftUI
import Combine

struct StoryCell : View {
    
    var provider : StoryCellViewModelMapper
    var item: Item
    
    init(item: Item) {
        self.provider = StoryCellViewModelMapper(item: item)
        self.item = item
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(provider.viewModel.title)")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                Text("\(provider.viewModel.url)")
                    .font(.subheadline)
            }
            Spacer()
            VStack (alignment: .trailing) {
                Text("\(provider.viewModel.points) points")
                    .font(.footnote)
                Text("\(provider.viewModel.comments) comments")
                    .font(.footnote)
                Text("\(provider.viewModel.timeAgo)")
                    .font(.footnote)
            }
        }
    }
}

/// This is the view model that this one `View` cares about.
struct StoryCellViewModel: Equatable {
    var title: String
    var url: String
    var points: Int
    var comments: Int
    var timeAgo: String
}

/// Turn the global state object into a single View Model publisher
class StoryCellViewModelMapper {
    var item: Item
    var viewModel: StoryCellViewModel
    
    init(item: Item) {
        self.item = item
        let shortURL = URL(string: item.url)?.host
        let postDate = Date(timeIntervalSince1970: Double(item.time))
        let now = Date()
        let dateString = RelativeDateTimeFormatter().localizedString(for: postDate, relativeTo: now)
        self.viewModel = StoryCellViewModel(title: item.title,
                                            url: shortURL ?? "",
                                            points: item.score,
                                            comments: item.descendants ?? 0,
                                            timeAgo: dateString)
    }
}

#if DEBUG
var item = Item(id: 0, type: "story", by: "mrmufungo", time: 1561849786, url: "https://fauna.com/blog/demystifying-database-systems-correctness-anomalies-under-serializable-isolation", score: 43, title: "Demystifying Databases: Correctness Anomalies Under Serializable Isolation", isLoaded: true)
struct StoryCell_Previews : PreviewProvider {
    static var previews: some View {
        
        StoryCell(item: item)
    }
}
#endif
