//
//  CreatorDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

struct CreatorDto: MappedEntity{
    let id: Int?
    let fullName: String?
    let thumbnail: ThumbnailDto?
    
    func toEntity() -> Entity {
        return Entity(id: self.id ?? 0,
                      title: self.fullName ?? "",
                      description: "",
                      imageUrl: thumbnail?.getThumbnailUrl() ?? "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg",
                      date: Date()) // TODO: convert Date properly
    }
    
    func entityName() -> String {
        return "creator"
    }
    
    func entityNamePlural() -> String {
        return "creators"
    }
}
