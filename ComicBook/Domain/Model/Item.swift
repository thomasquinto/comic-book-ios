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
    let itemType: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


