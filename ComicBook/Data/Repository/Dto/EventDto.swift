//
//  EventDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

struct EventDto: MappedItem {
    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: ThumbnailDto?
    
    func toItem() -> Item {
        return Item(id: self.id ?? 0,
                    itemType: .event,
                    name: self.title ?? "",
                    description: self.description ?? "",
                    date: Date(),
                    imageUrl: thumbnail?.getThumbnailUrl() ?? ThumbnailDto.missingImageUrl)
    }
}
