//
//  Item.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/27/24.
//

import Foundation

struct Item: Identifiable, Hashable {
    let id: Int
    let itemType: ItemType
    let name: String
    let description: String
    let date: Date
    let imageUrl: String

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
    case favorite = "favorites"
}


