//
//  MappedItem.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/29/24.
//

import Foundation

protocol MappedItem: Codable, Identifiable {
    func toItem() -> Item
}
