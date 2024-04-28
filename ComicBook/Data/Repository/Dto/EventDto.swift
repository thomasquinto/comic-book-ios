//
//  EventDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

struct EventDto: Codable, Identifiable{
    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: ThumbnailDto?
}
