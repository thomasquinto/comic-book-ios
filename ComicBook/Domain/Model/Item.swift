//
//  Item.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

struct Item: Identifiable, Hashable {
    let id: Int
    let title: String
    let description: String
    let imageUrl: String
    let date: Date
    let itemType: ItemType

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum ItemType: String {
    case comic = "comics"
    case character = "characters"
    case creator = "creators"
    case event = "events"
    case series = "series"
    case story = "stories"
}


