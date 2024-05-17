//
//  SeriesDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/28/24.
//

import Foundation

struct SeriesDto: MappedItem {
    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: ThumbnailDto?
    
    func toItem() -> Item {
        return Item(id: self.id ?? 0,
                    itemType: .series,
                    name: self.title ?? "",
                    description: self.description ?? "",
                    date: Date(),
                    imageUrl: thumbnail?.getThumbnailUrl() ?? ThumbnailDto.missingImageUrl)
    }
}
