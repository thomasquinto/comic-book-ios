//
//  CreatorsDataDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

struct CreatorsDataDto: Codable{
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [CreatorDto]
}
