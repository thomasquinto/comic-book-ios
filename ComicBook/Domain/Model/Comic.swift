//
//  Comic.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

struct Comic: Identifiable, Hashable {
    let id: Int
    let title: String
    let description: String
    let thumbnailUrl: String
    let modified: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
