//
//  LocalDatabase.swift
//  ComicBook
//
//  Created by Thomas Quinto on 5/16/24.
//

import Foundation
import UIKit
import SwiftData

@MainActor
class LocalDatabase: NSObject {
    
    static let shared = LocalDatabase()

    private let persistentContainer: ModelContainer = {
        do {
            let container = try ModelContainer(
                for: Schema([ItemEntity.self, ItemRequestEntity.self]),
                configurations: ModelConfiguration()
            )
            container.mainContext.autosaveEnabled = true
            return container
        } catch {
            fatalError("Failed to create a container")
        }
    }()
    
    func saveItemRequest(itemType: ItemType,
                         prefix: String,
                         id: Int,
                         offset: Int,
                         limit: Int,
                         orderBy: String,
                         startsWith: String,
                         items: [Item]) async {
        
        var itemEntities = [] as [ItemEntity]
        for (index, item) in items.enumerated() {
            itemEntities.append(ItemEntity(item: item, index: index))
        }
               
        let paramKey = ItemRequestEntity.generateParamKey(itemType: itemType, prefix: prefix, id: id)
        let paramExtras = ItemRequestEntity.generateParamExtras(offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith)
        let itemRequestEntity = ItemRequestEntity(paramKey: paramKey, paramExtras: paramExtras, itemEntities: itemEntities)
        
        print("Caching items for key: \(paramKey)-\(paramExtras)")
        
        persistentContainer.mainContext.insert(itemRequestEntity)
    }
    
    func retrieveItemRequest(itemType: ItemType,
                             prefix: String,
                             id: Int,
                             offset: Int,
                             limit: Int,
                             orderBy: String,
                             startsWith: String) -> [Item]? {
        let paramKey = ItemRequestEntity.generateParamKey(itemType: itemType, prefix: prefix, id: id)
        let paramExtras = ItemRequestEntity.generateParamExtras(offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith)
        
        print("Looking for cached items for key: \(paramKey)-\(paramExtras)")
        
        do {
            let itemRequestEntity = try persistentContainer.mainContext.fetch(
                FetchDescriptor<ItemRequestEntity>(
                    predicate: #Predicate {
                        $0.paramKey == paramKey &&
                        $0.paramExtras == paramExtras
                    }
                )
            ).first
            
            if let itemRequestEntity {
                print("Found cached items for key: \(paramKey)-\(paramExtras)")
                let itemEntities = itemRequestEntity.itemEntities.sorted(by: { $0.index < $1.index })
                return itemEntities.map { itemEntity in
                    itemEntity.toItem()
                }
            } else {
                return nil
            }
        } catch {
            print("Error fetching cached items for key: \(paramKey)-\(paramExtras): \(error)")
            return nil
        }
    }
    
    func clearItemRequestForKey(itemType: ItemType,
                                prefix: String,
                                id: Int) {
        let paramKey = ItemRequestEntity.generateParamKey(itemType: itemType, prefix: prefix, id: id)
        
        print("Clearing cached items for key: \(paramKey)")
        
        do {
            let itemRequestEntities = try persistentContainer.mainContext.fetch(
                FetchDescriptor<ItemRequestEntity>(
                    predicate: #Predicate {
                        $0.paramKey == paramKey
                    }
                )
            )
            
            itemRequestEntities.forEach { itemRequestEntity in
                print("Deleting cached items for key: \(itemRequestEntity.paramKey)-\(itemRequestEntity.paramExtras)")
                persistentContainer.mainContext.delete(itemRequestEntity)
            }
            
        } catch {
            print("Error clearing cached items for key: \(paramKey): \(error)")
        }
    }
    
    func clearItemRequests() {
        print("Clearing all cached items")
        
        do {
            let itemRequestEntities = try persistentContainer.mainContext.fetch(
                FetchDescriptor<ItemRequestEntity>()
            )
            
            itemRequestEntities.forEach { itemRequestEntity in
                print("Deleting cached items for id: \(itemRequestEntity.id)")
                persistentContainer.mainContext.delete(itemRequestEntity)
            }
            
        } catch {
            print("Error clearing all cached items: \(error)")
        }
    }
}
