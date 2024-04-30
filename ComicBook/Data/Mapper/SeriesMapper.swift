//
//  SeriesMapper.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/28/24.
//

import Foundation

extension SeriesDto {
    
    func getThumbnailUrl() -> String {
        if let thumbnail = self.thumbnail {
            return "\(thumbnail.path).\(thumbnail.suffix)".replacing("http://", with: "https://")
        } else {
            return "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg"
        }
    }
 
    var toEntity: Entity {
        return Entity(id: self.id ?? 0,
                      title: self.title ?? "",
                      description: self.description ?? "",
                      imageUrl: getThumbnailUrl(),
                      date: Date()) // TODO: convert Date properly
    }
}
