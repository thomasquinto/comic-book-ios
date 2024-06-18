//
//  CreatorDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

struct CreatorDto: MappedItem{
    let id: Int?
    let fullName: String?
    let thumbnail: ThumbnailDto?
    
    func toItem() -> Item {
        return Item(id: generateId(id: self.id ?? 0, itemType: .creator),
                    itemId: self.id ?? 0,
                    itemType: .creator,
                    name: self.fullName ?? "",
                    description: "",
                    date: Date(),
                    imageUrl: thumbnail?.getThumbnailUrl() ?? ThumbnailDto.missingImageUrl)
    }
}
