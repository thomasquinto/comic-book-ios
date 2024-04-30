//
//  SeriesDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/28/24.
//

import Foundation

struct SeriesDto: MappedEntity {
    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: ThumbnailDto?
    
    func toEntity() -> Entity {
        return Entity(id: self.id ?? 0,
                      title: self.title ?? "",
                      description: self.description ?? "",
                      imageUrl: thumbnail?.getThumbnailUrl() ?? "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg",
                      date: Date()) // TODO: convert Date properly
    }
    
    func entityName() -> String {
        return "series"
    }
    
    func entityNamePlural() -> String {
        return "series"
    }
}
