//
//  SeriesDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/28/24.
//

import Foundation

struct SeriesDto: Codable, Identifiable{
    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: ThumbnailDto?
}
