//
//  CreatorMapper.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

extension CreatorDto {
    
    func getThumbnailUrl() -> String {
        return "\(self.thumbnail!.path).\(self.thumbnail!.suffix)".replacing("http://", with: "https://")
    }
 
    var toEntity: Entity {
        return Entity(id: self.id ?? 0,
                      title: self.fullName ?? "",
                      description: "",
                      imageUrl: getThumbnailUrl(),
                      date: Date()) // TODO: convert Date properly
    }
}
