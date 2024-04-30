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
    
    
    func getCharacters(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        return try await remote.getCharacters(nameStartsWith: nameStartsWith, offset: offset, limit: limit)
    }
    
    func getCharacterComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getCharacterComics(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCharacterEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getCharacterEvents(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCharacterSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getCharacterSeries(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCharacterStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getCharacterStories(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
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
    
    func getCreators(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        return try await remote.getCreators(nameStartsWith: nameStartsWith, offset: offset, limit: limit)
    }
    
    func getCreatorComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getCreatorComics(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCreatorEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getComicEvents(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCreatorSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getCreatorSeries(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getCreatorStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getCreatorStories(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
 
    func getEvents(nameStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        return try await remote.getEvents(nameStartsWith: nameStartsWith, offset: offset, limit: limit)
    }
    
    func getEventCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getEventCharacters(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getEventComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getEventComics(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getEventCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getEventCreators(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getEventSeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getEventSeries(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getEventStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getEventStories(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getSeries(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        return try await remote.getSeries(titleStartsWith: titleStartsWith, offset: offset, limit: limit)
    }
    
    func getSeriesCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getSeriesCharacters(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getSeriesComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getSeriesComics(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getSeriesCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getSeriesCreators(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getSeriesEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getSeriesEvents(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getSeriesStories(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getSeriesStories(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getStories(titleStartsWith: String, offset: Int, limit: Int) async throws -> [Entity] {
        return try await remote.getStories(titleStartsWith: titleStartsWith, offset: offset, limit: limit)
    }
    
    func getStoryCharacters(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getStoryCharacters(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getStoryComics(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getStoryComics(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getStoryCreators(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getStoryCreators(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getStoryEvents(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getStoryEvents(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
    
    func getStorySeries(id: Int, offset: Int, limit: Int, orderBy: String?) async throws -> [Entity] {
        return try await remote.getStorySeries(id: id, offset: offset, limit: limit, orderBy: orderBy)
    }
  
}
