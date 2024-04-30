//
//  DataDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/29/24.
//

import Foundation

struct DataDto<T: Codable>: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [T]
}
