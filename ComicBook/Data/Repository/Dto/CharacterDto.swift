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
        return Item(id: self.id ?? 0,
                    title: self.name ?? "",
                    description: self.description ?? "",
                    imageUrl: thumbnail?.getThumbnailUrl() ?? "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg",
                    date: Date(),
                    itemType: .character) // TODO: convert Date properly
    }
}
