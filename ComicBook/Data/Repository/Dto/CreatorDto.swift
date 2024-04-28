//
//  CreatorDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

struct CreatorDto: Codable, Identifiable{
    let id: Int?
    let fullName: String?
    let thumbnail: ThumbnailDto?
}
