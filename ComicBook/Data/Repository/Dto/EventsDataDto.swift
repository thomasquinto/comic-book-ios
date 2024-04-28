//
//  EventsDataDto.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

struct EventsDataDto: Codable{
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [EventDto]
}
