//
//  ComicBookRepositoryImpl.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation
import SwiftData

struct ComicBookRepositoryImpl: ComicBookRepository {
    
    fileprivate let remote: ComicBookRemote
    private let useCache = true
    
    private init(remote: ComicBookRemote){
        self.remote = remote
    }
    
    /* TODO: Use dependency injection properly
    typealias ComicBookInstance = (ComicBookRemote) -> ComicBookRepositoryImpl

    static let sharedInstance: ComicBookInstance = { remoteRepo in
        return ComicBookRepositoryImpl(remote: remoteRepo)
    }
     */
    static let shared: ComicBookRepository = ComicBookRepositoryImpl(remote: ComicBookRemote.shared)
    
    func getItems(
        getRemoteItems: (String, Int, Int, Int, String, String) async throws -> [Item],
        itemType: ItemType,
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String,
        fetchFromRemote: Bool
    ) async throws -> [Item] {
        if !useCache { // only for internal testing
            return try await getRemoteItems(prefix, id, offset, limit, orderBy, startsWith)
        }
        
        if fetchFromRemote {
            await LocalDatabase.shared.clearItemRequestsForKey(itemType: itemType, prefix: prefix, id: id)
        } else {
            let items = await LocalDatabase.shared.retrieveItemRequest(itemType: itemType, prefix: prefix, id: id, offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith)
            if let items = items {
                return items
            }
        }
        
        let items = try await getRemoteItems(prefix, id, offset, limit, orderBy, startsWith)
        
        await LocalDatabase.shared.saveItemRequest(itemType: itemType, prefix: prefix, id: id, offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith, items: items)
        
        return items
    }
    
    func getCharacters(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String,
        fetchFromRemote: Bool
    ) async throws -> [Item] {
        return try await getItems(getRemoteItems: remote.getCharacters, itemType: .character, prefix: prefix, id: id, offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith, fetchFromRemote: fetchFromRemote)
    }
    
    func getComics(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String,
        fetchFromRemote: Bool
    ) async throws -> [Item] {
        return try await getItems(getRemoteItems: remote.getComics, itemType: .comic, prefix: prefix, id: id, offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith, fetchFromRemote: fetchFromRemote)
    }
    
    func getCreators(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String,
        fetchFromRemote: Bool
    ) async throws -> [Item] {
        return try await getItems(getRemoteItems: remote.getCreators, itemType: .creator, prefix: prefix, id: id, offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith, fetchFromRemote: fetchFromRemote)
    }
    
    func getEvents(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String,
        fetchFromRemote: Bool
    ) async throws -> [Item] {
        return try await getItems(getRemoteItems: remote.getEvents, itemType: .event, prefix: prefix, id: id, offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith, fetchFromRemote: fetchFromRemote)
    }

    func getSeries(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String,
        fetchFromRemote: Bool
    ) async throws -> [Item] {
        return try await getItems(getRemoteItems: remote.getSeries, itemType: .series, prefix: prefix, id: id, offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith, fetchFromRemote: fetchFromRemote)
    }
    
    func getStories(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String,
        fetchFromRemote: Bool
    ) async throws -> [Item] {
        return try await getItems(getRemoteItems: remote.getStories, itemType: .story, prefix: prefix, id: id, offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith, fetchFromRemote: fetchFromRemote)
    }
    
    func deleteCache() async {
        await LocalDatabase.shared.clearItemRequests()
    }
    
    func retrieveFavoriteItems() async -> [Item] {
        return await LocalDatabase.shared.retrieveFavoriteItems()
    }
    
    func updateFavorite(item: Item, isFavorite: Bool) async {
        await LocalDatabase.shared.updateFavorite(item: item, isFavorite: isFavorite)
    }
}
