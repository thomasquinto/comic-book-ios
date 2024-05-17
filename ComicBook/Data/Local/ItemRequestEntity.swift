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
    @Attribute(.unique)
    var compoundKey: String
    var paramKey: String
    var paramExtras: String
    @Relationship(deleteRule: .cascade)
    var itemEntities: [ItemEntity]
    var created: Date = Date()
    
    init(paramKey: String, paramExtras: String, itemEntities: [ItemEntity]) {
        self.compoundKey = ItemRequestEntity.generateCompoundKey(paramKey: paramKey, paramExtras: paramExtras)
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
    
    static func generateCompoundKey(paramKey: String, paramExtras: String) -> String {
        return paramKey + "-" + paramExtras
    }
}
