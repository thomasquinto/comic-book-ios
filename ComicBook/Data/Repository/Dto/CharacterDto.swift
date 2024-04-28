//
//  CharactersDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

struct CharacterDto: Codable, Identifiable{
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: ThumbnailDto?
}
