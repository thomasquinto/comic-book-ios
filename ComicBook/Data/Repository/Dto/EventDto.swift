//
//  EventDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

struct EventDto: MappedEntity {
    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: ThumbnailDto?
    
    func toEntity() -> Entity {
        return Entity(id: self.id ?? 0,
                      title: self.title ?? "",
                      description: self.description ?? "",
                      imageUrl: thumbnail?.getThumbnailUrl() ?? "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg",
                      date: Date(),
                      entityName: "Events") // TODO: convert Date properly
    }
}
