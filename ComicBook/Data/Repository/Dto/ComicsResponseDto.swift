//
//  ComicsResponseDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

struct ComicsResponseDto: Codable{
    let code: Int
    let status: String
    let data: ComicsDataDto
}

