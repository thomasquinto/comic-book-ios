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
    
    func getComics(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        return try await remote.getComics(titleStartsWith: titleStartsWith, offset: offset, limit: limit)
    }
    
    func getComicCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getComicCharacters(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getComicCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getComicCreators(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getComicEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getComicEvents(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getComicStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getComicStories(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCharacters(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        return try await remote.getCharacters(nameStartsWith: nameStartsWith, offset: offset, limit: limit)
    }
    
    func getSeries(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        return try await remote.getSeries(titleStartsWith: titleStartsWith, offset: offset, limit: limit)
    }
    
    func getEvents(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        return try await remote.getEvents(nameStartsWith: nameStartsWith, offset: offset, limit: limit)
    }
    
    func getStories(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        return try await remote.getStories(titleStartsWith: titleStartsWith, offset: offset, limit: limit)
    }
    
    func getCreators(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        return try await remote.getCreators(nameStartsWith: nameStartsWith, offset: offset, limit: limit)
    }
}
