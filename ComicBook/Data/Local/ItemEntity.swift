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
    @Attribute(.unique)
    var compoundKey: String
    var index: Int
    var id: Int
    var itemType: String
    var name: String
    var desc: String
    var date: Date
    var imageUrl: String
    var isFavorite: Bool = false
    var updated: Date = Date()
    
    init(index: Int, id: Int, itemType: String, name: String, desc: String, date: Date, imageUrl: String) {
        self.compoundKey = ItemEntity.generateCompoundKey(id: id, itemTypeValue: itemType)
        self.index = index
        self.id = id
        self.itemType = itemType
        self.name = name
        self.desc = desc
        self.date = date
        self.imageUrl = imageUrl
    }
    
    convenience init(item: Item, index: Int) {
        self.init(index: index,
                  id: item.id,
                  itemType: item.itemType.rawValue,
                  name: item.name,
                  desc: item.description,
                  date: item.date,
                  imageUrl: item.imageUrl)
    }
    
    func toItem() -> Item {
        return Item(id: id,
                    itemType: ItemType(rawValue: itemType)!,
                    name: name,
                    description: desc,
                    date: date,
                    imageUrl: imageUrl)
    }
    
    static func generateCompoundKey(id: Int, itemTypeValue: String) -> String {
        return "\(id)_\(itemTypeValue)"
    }
}
