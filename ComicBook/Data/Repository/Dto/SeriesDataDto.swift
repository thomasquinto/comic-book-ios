//
//  SeriesDataDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/28/24.
//

import Foundation

struct SeriesDataDto: Codable{
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [SeriesDto]
}
