//
//  ComicMapper.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

extension ComicDto {
    var toComic: Comic {
        return Comic(id: self.id ?? 0,
                     title: self.title ?? "",
                     description: self.description ?? "",
                     thumbnailUrl: "\(self.thumbnail!.path).\(self.thumbnail!.suffix)".replacing("http://", with: "https://"),
                     modified: Date()) // TODO: convert Date properly
    }
}
