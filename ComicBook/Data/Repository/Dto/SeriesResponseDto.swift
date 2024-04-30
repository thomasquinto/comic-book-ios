//
//  SeriesResponseDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/28/24.
//

import Foundation

struct SeriesResponseDto: Codable{
    let code: Int
    let status: String
    let data: SeriesDataDto
}
