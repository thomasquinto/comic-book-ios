//
//  ItemRequestEntity.swift
//  ComicBook
//
//  Created by Thomas Quinto on 5/16/24.
//

import Foundation
import SwiftData

@Model
class ItemRequestEntity: Identifiable {
    var paramKey: String
    var paramExtras: String
    @Relationship(deleteRule: .cascade)
    var itemEntities: [ItemEntity]
    var created: Date = Date()
    
    init(paramKey: String, paramExtras: String, itemEntities: [ItemEntity]) {
        self.paramKey = paramKey
        self.paramExtras = paramExtras
        self.itemEntities = itemEntities
    }
    
    static func generateParamKey(itemType: ItemType, prefix: String, id: Int) -> String {
        return "\(itemType.rawValue)-\(prefix)-\(id)"
    }
    
    static func generateParamExtras(offset: Int, limit: Int, orderBy: String, startsWith: String) -> String {
        return "\(offset)-\(limit)-\(orderBy)-\(startsWith)"
    }
  
}
