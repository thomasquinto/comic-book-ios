//
//  CharactersDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

struct CharacterDto: MappedItem {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: ThumbnailDto?
    
    func toItem() -> Item {
        return Item(id: generateId(id: self.id ?? 0, itemType: .character),
                    itemId: self.id ?? 0,
                    itemType: .character,
                    name: self.name ?? "",
                    description: self.description ?? "",
                    date: Date(),
                    imageUrl: thumbnail?.getThumbnailUrl() ?? ThumbnailDto.missingImageUrl)

    }
}
