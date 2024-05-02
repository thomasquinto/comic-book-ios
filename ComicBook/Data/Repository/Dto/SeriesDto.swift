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
                    title: self.title ?? "",
                    description: self.description ?? "",
                    imageUrl: thumbnail?.getThumbnailUrl() ?? "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg",
                    date: Date(),
                    itemType: .series) // TODO: convert Date properly
    }
}
