//
//  ComicDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

struct ComicDto: Codable, Identifiable{
    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: ThumbnailDto?
}

struct ThumbnailDto: Codable{
    let path: String
    // extension is JSON name
    let suffix: String
    
    enum CodingKeys: String, CodingKey{
        case path
        case suffix = "extension"
    }
    
}
