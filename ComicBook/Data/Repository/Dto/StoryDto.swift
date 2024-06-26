//
//  StoryDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

struct StoryDto: MappedItem {
    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: ThumbnailDto?
    
    func toItem() -> Item {
        return Item(id: generateId(id: self.id ?? 0, itemType: .story),
                    itemId: self.id ?? 0,
                    itemType: .story,
                    name: self.title ?? "",
                    description: self.description ?? "",
                    date: Date(),
                    imageUrl: thumbnail?.getThumbnailUrl() ?? ThumbnailDto.missingImageUrl)
    }
}
