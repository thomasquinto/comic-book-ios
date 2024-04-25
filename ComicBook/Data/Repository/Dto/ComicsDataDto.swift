//
//  ComicsDataDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

struct ComicsDataDto: Codable{
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [ComicDto]
}
