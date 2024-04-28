//
//  CreatorsResponseDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

struct CreatorsResponseDto: Codable{
    let code: Int
    let status: String
    let data: CreatorsDataDto
}
