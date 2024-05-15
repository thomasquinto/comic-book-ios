//
//  ComicBookRepositoryImpl.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/16/24.
//

import Foundation

struct ComicBookRepositoryImpl: ComicBookRepository {
    
    fileprivate let remote: ComicBookRemote
    
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
    
    func getCharacters(
        prefix: String,
        id: Int,
        offset: Int,
        limit: Int,
        orderBy: String,
        startsWith: String,
        fetchFromRemote: Bool
    ) async throws -> [Item] {
        return try await remote.getCharacters(prefix: prefix, id: id, offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith)
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
        return try await remote.getComics(prefix: prefix, id: id, offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith)
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
        return try await remote.getCreators(prefix: prefix, id: id, offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith)
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
        return try await remote.getEvents(prefix: prefix, id: id, offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith)
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
        return try await remote.getSeries(prefix: prefix, id: id, offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith)
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
        return try await remote.getStories(prefix: prefix, id: id, offset: offset, limit: limit, orderBy: orderBy, startsWith: startsWith)
    }
}
