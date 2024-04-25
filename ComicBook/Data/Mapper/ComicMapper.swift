//
//  ComicWrapper.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

extension ComicDto {
    toComic: Comic {
        return Comic(id: self.id, 
                     title: self.title,
                     description: self.description,
                     thumbnailUrl: self.thumbnailUrl,
                     modified: self.modified)
    }
}

extension Comic {
    toComicEntity: ComicEntity {
        return ComicEntity(id: self.id,
                           title: self.title,
                           description: self.description,
                           thumbnailUrl: self.thumbnailUrl,
                           modified: self.modified)
    }
}
