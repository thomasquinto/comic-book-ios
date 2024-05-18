//
//  ItemEntity.swift
//  ComicBook
//
//  Created by Thomas Quinto on 5/16/24.
//

import Foundation
import SwiftData

@Model
class ItemEntity: Identifiable {
    var index: Int
    var itemId: Int
    var itemType: String
    var name: String
    var desc: String
    var date: Date
    var imageUrl: String
    var isFavorite: Bool = false
    var updatedAt: Date = Date()
    
    init(index: Int, itemId: Int, itemType: String, name: String, desc: String, date: Date, imageUrl: String) {
        self.index = index
        self.itemId = itemId
        self.itemType = itemType
        self.name = name
        self.desc = desc
        self.date = date
        self.imageUrl = imageUrl
    }
    
    convenience init(item: Item, index: Int) {
        self.init(index: index,
                  itemId: item.id,
                  itemType: item.itemType.rawValue,
                  name: item.name,
                  desc: item.description,
                  date: item.date,
                  imageUrl: item.imageUrl)
    }
    
    func toItem() -> Item {
        return Item(id: itemId,
                    itemType: ItemType(rawValue: itemType)!,
                    name: name,
                    description: desc,
                    date: date,
                    imageUrl: imageUrl)
    }
   
}
