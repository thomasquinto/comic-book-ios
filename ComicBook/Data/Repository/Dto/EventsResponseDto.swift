//
//  EventsResponseDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

struct EventsResponseDto: Codable{
    let code: Int
    let status: String
    let data: EventsDataDto
}
